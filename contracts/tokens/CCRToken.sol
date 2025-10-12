// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title CCRToken - Carbon Credit Token
 * @dev ERC20 token para créditos de carbono verificados
 * @author ESG Token Ecosystem
 */
contract CCRToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18; // 100 million CCR (representing 100M tons CO2)
    uint256 public constant INITIAL_SUPPLY = 10_000_000 * 10**18; // 10 million CCR initial
    
    // Carbon Credit Configuration
    uint256 public constant TONS_PER_TOKEN = 1; // 1 CCR = 1 ton CO2 equivalent
    uint256 public constant VERIFICATION_PERIOD = 365 days; // 1 year verification period
    
    // Carbon Credit Registry
    struct CarbonCredit {
        uint256 creditId;
        string projectName;
        string projectType; // e.g., "Renewable Energy", "Forest Conservation", "Carbon Capture"
        string location;
        uint256 co2Equivalent; // CO2 equivalent in tons
        uint256 verificationDate;
        uint256 expiryDate;
        string verificationStandard; // e.g., "VCS", "Gold Standard", "CDM"
        bool isRetired;
        address issuer;
        string metadataURI; // IPFS URI for additional project data
    }
    
    mapping(uint256 => CarbonCredit) public carbonCredits;
    mapping(address => uint256[]) public userCredits;
    mapping(string => bool) public verifiedStandards;
    
    uint256 public nextCreditId = 1;
    uint256 public totalCreditsIssued = 0;
    uint256 public totalCreditsRetired = 0;
    
    // ESG Integration
    address public gstToken; // Reference to GST Token
    address public carbonOracle; // Carbon data oracle
    
    // Events
    event CCRMinted(address indexed to, uint256 amount, string reason);
    event CCRBurned(address indexed from, uint256 amount, string reason);
    event CarbonCreditIssued(uint256 indexed creditId, address indexed issuer, string projectName, uint256 co2Equivalent);
    event CarbonCreditRetired(uint256 indexed creditId, address indexed retirer, uint256 amount, string reason);
    event GSTTokenSet(address indexed gstToken);
    event CarbonOracleSet(address indexed carbonOracle);
    event StandardVerified(string standard, bool verified);
    
    constructor() ERC20("Carbon Credit Token", "CCR") Ownable() {
        _mint(msg.sender, INITIAL_SUPPLY);
        
        // Initialize verified standards
        verifiedStandards["VCS"] = true;
        verifiedStandards["Gold Standard"] = true;
        verifiedStandards["CDM"] = true;
        verifiedStandards["CAR"] = true;
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mints new CCR tokens. Only callable by the owner.
     * @param to The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     * @param reason The reason for minting.
     */
    function mint(address to, uint256 amount, string memory reason) public onlyOwner nonReentrant {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
        emit CCRMinted(to, amount, reason);
    }
    
    /**
     * @dev Burns CCR tokens from a specified address.
     * @param from The address to burn tokens from.
     * @param amount The amount of tokens to burn.
     * @param reason The reason for burning.
     */
    function burn(address from, uint256 amount, string memory reason) external onlyOwner {
        _burn(from, amount);
        emit CCRBurned(from, amount, reason);
    }
    
    // ============ CARBON CREDIT MANAGEMENT ============
    
    /**
     * @dev Issues a new carbon credit.
     * @param projectName The name of the carbon project.
     * @param projectType The type of project (e.g., "Renewable Energy").
     * @param location The location of the project.
     * @param co2Equivalent The CO2 equivalent in tons.
     * @param verificationStandard The verification standard used.
     * @param metadataURI The IPFS URI for additional project data.
     * @return creditId The ID of the issued credit.
     */
    function issueCarbonCredit(
        string memory projectName,
        string memory projectType,
        string memory location,
        uint256 co2Equivalent,
        string memory verificationStandard,
        string memory metadataURI
    ) external onlyOwner nonReentrant returns (uint256) {
        require(bytes(projectName).length > 0, "Project name cannot be empty");
        require(co2Equivalent > 0, "CO2 equivalent must be positive");
        require(verifiedStandards[verificationStandard], "Verification standard not recognized");
        
        uint256 creditId = nextCreditId++;
        uint256 tokenAmount = co2Equivalent * 10**18; // Convert tons to token amount
        
        carbonCredits[creditId] = CarbonCredit({
            creditId: creditId,
            projectName: projectName,
            projectType: projectType,
            location: location,
            co2Equivalent: co2Equivalent,
            verificationDate: block.timestamp,
            expiryDate: block.timestamp + VERIFICATION_PERIOD,
            verificationStandard: verificationStandard,
            isRetired: false,
            issuer: msg.sender,
            metadataURI: metadataURI
        });
        
        // Mint tokens to the issuer
        _mint(msg.sender, tokenAmount);
        userCredits[msg.sender].push(creditId);
        
        totalCreditsIssued += co2Equivalent;
        
        emit CarbonCreditIssued(creditId, msg.sender, projectName, co2Equivalent);
        emit CCRMinted(msg.sender, tokenAmount, "Carbon Credit Issuance");
        
        return creditId;
    }
    
    /**
     * @dev Retires carbon credits (burns tokens and marks credit as retired).
     * @param creditId The ID of the credit to retire.
     * @param amount The amount of tokens to retire.
     * @param reason The reason for retirement.
     */
    function retireCarbonCredit(
        uint256 creditId,
        uint256 amount,
        string memory reason
    ) external nonReentrant {
        require(creditId > 0 && creditId < nextCreditId, "Invalid credit ID");
        require(amount > 0, "Amount must be positive");
        require(balanceOf(msg.sender) >= amount, "Insufficient CCR balance");
        
        CarbonCredit storage credit = carbonCredits[creditId];
        require(!credit.isRetired, "Credit already retired");
        require(block.timestamp <= credit.expiryDate, "Credit has expired");
        
        // Burn tokens
        _burn(msg.sender, amount);
        
        // Mark credit as retired if fully retired
        uint256 remainingAmount = credit.co2Equivalent * 10**18 - amount;
        if (remainingAmount <= 0) {
            credit.isRetired = true;
            totalCreditsRetired += credit.co2Equivalent;
        }
        
        emit CarbonCreditRetired(creditId, msg.sender, amount, reason);
        emit CCRBurned(msg.sender, amount, reason);
    }
    
    /**
     * @dev Gets carbon credit information.
     * @param creditId The ID of the credit.
     * @return CarbonCredit The carbon credit information.
     */
    function getCarbonCredit(uint256 creditId) external view returns (CarbonCredit memory) {
        require(creditId > 0 && creditId < nextCreditId, "Invalid credit ID");
        return carbonCredits[creditId];
    }
    
    /**
     * @dev Gets user's carbon credits.
     * @param user The address of the user.
     * @return uint256[] Array of credit IDs owned by the user.
     */
    function getUserCredits(address user) external view returns (uint256[] memory) {
        return userCredits[user];
    }
    
    // ============ ESG INTEGRATION ============
    
    /**
     * @dev Sets the GST Token address for cross-token rewards.
     * @param _gstToken The address of the GST Token contract.
     */
    function setGSTToken(address _gstToken) external onlyOwner {
        require(_gstToken != address(0), "GST Token address cannot be zero");
        gstToken = _gstToken;
        emit GSTTokenSet(_gstToken);
    }
    
    /**
     * @dev Sets the Carbon Oracle address for external carbon data.
     * @param _carbonOracle The address of the Carbon Oracle contract.
     */
    function setCarbonOracle(address _carbonOracle) external onlyOwner {
        require(_carbonOracle != address(0), "Carbon Oracle address cannot be zero");
        carbonOracle = _carbonOracle;
        emit CarbonOracleSet(_carbonOracle);
    }
    
    /**
     * @dev Verifies a new carbon standard.
     * @param standard The name of the standard.
     * @param verified Whether the standard is verified.
     */
    function verifyStandard(string memory standard, bool verified) external onlyOwner {
        verifiedStandards[standard] = verified;
        emit StandardVerified(standard, verified);
    }
    
    // ============ CARBON MARKETPLACE ============
    
    /**
     * @dev Transfers carbon credits between users.
     * @param to The address to transfer to.
     * @param amount The amount of CCR tokens to transfer.
     * @return bool True if transfer was successful.
     */
    function transferCarbonCredits(address to, uint256 amount) external nonReentrant returns (bool) {
        require(to != address(0), "Transfer to zero address");
        require(balanceOf(msg.sender) >= amount, "Insufficient CCR balance");
        
        _transfer(msg.sender, to, amount);
        return true;
    }
    
    /**
     * @dev Calculates the CO2 equivalent for a given amount of tokens.
     * @param tokenAmount The amount of tokens.
     * @return uint256 The CO2 equivalent in tons.
     */
    function getCO2Equivalent(uint256 tokenAmount) external pure returns (uint256) {
        return tokenAmount / 10**18; // 1 token = 1 ton CO2
    }
    
    /**
     * @dev Calculates the token amount for a given CO2 equivalent.
     * @param co2Tons The CO2 equivalent in tons.
     * @return uint256 The token amount.
     */
    function getTokenAmount(uint256 co2Tons) external pure returns (uint256) {
        return co2Tons * 10**18; // 1 ton CO2 = 1 token
    }
    
    // ============ ECOSYSTEM STATS ============
    
    /**
     * @dev Gets overall Carbon Credit Ecosystem statistics.
     * @return totalSupply_ Current total supply of CCR.
     * @return maxSupply_ Maximum possible supply of CCR.
     * @return totalCreditsIssued_ Total credits issued in tons CO2.
     * @return totalCreditsRetired_ Total credits retired in tons CO2.
     * @return activeCredits_ Active credits in tons CO2.
     */
    function getCarbonEcosystemStats() public view returns (
        uint256 totalSupply_,
        uint256 maxSupply_,
        uint256 totalCreditsIssued_,
        uint256 totalCreditsRetired_,
        uint256 activeCredits_
    ) {
        totalSupply_ = totalSupply();
        maxSupply_ = MAX_SUPPLY;
        totalCreditsIssued_ = totalCreditsIssued;
        totalCreditsRetired_ = totalCreditsRetired;
        activeCredits_ = totalCreditsIssued_ - totalCreditsRetired_;
    }
    
    // ============ CROSS-TOKEN INTEGRATION ============
    
    /**
     * @dev Converts CCR to GST tokens (if GST token is set).
     * @param amount The amount of CCR to convert.
     * @return bool True if conversion was successful.
     */
    function convertToGST(uint256 amount) external nonReentrant returns (bool) {
        require(gstToken != address(0), "GST Token not set");
        require(balanceOf(msg.sender) >= amount, "Insufficient CCR balance");
        
        // Burn CCR tokens
        _burn(msg.sender, amount);
        
        // Note: In a real implementation, this would interact with the GST token contract
        // to mint equivalent GST tokens. For now, we'll just emit an event.
        emit CCRBurned(msg.sender, amount, "Converted to GST");
        
        return true;
    }
}