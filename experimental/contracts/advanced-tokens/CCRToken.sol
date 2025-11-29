// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/IESToken.sol";

/**
 * @title CCRToken - Carbon Credit Token
 * @dev ERC20 token para créditos de carbono verificados
 * @author ESG Token Ecosystem
 * 
 * Features:
 * - Créditos de carbono verificados
 * - Sistema de aposentadoria (retirement)
 * - Marketplace de créditos
 * - Verificação de integridade
 * - Integração com protocolos de carbono
 */
contract CCRToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard, IESToken {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18; // 1 million CCR (1 CCR = 1 ton CO2)
    uint256 public constant INITIAL_SUPPLY = 100_000 * 10**18; // 100,000 CCR initial
    
    // Carbon Credit System
    struct CarbonCredit {
        uint256 id;
        string projectId;
        string standard; // VCS, Gold Standard, etc.
        uint256 vintage; // Year of generation
        string country;
        string projectType;
        uint256 co2Reduction; // Tons of CO2 reduced
        bool verified;
        bool retired;
        address issuer;
        uint256 issueDate;
        uint256 retirementDate;
    }
    
    mapping(uint256 => CarbonCredit) public carbonCredits;
    mapping(address => uint256[]) public userCredits;
    mapping(string => bool) public verifiedProjects;
    uint256 public creditCount;
    
    // Retirement System
    struct Retirement {
        uint256 creditId;
        address retirer;
        string purpose;
        uint256 amount;
        uint256 timestamp;
        string certificate;
    }
    
    mapping(uint256 => Retirement) public retirements;
    mapping(address => uint256[]) public userRetirements;
    uint256 public retirementCount;
    
    // Marketplace System
    struct Listing {
        uint256 id;
        uint256 creditId;
        address seller;
        uint256 price; // Price per ton in wei
        uint256 amount;
        bool active;
        uint256 listingDate;
    }
    
    mapping(uint256 => Listing) public listings;
    mapping(address => uint256[]) public userListings;
    uint256 public listingCount;
    
    // Verification System
    mapping(address => bool) public verifiers;
    mapping(string => bool) public approvedStandards;
    
    // Events
    event CarbonCreditIssued(uint256 indexed creditId, address indexed issuer, string projectId, uint256 amount);
    event CarbonCreditRetired(uint256 indexed creditId, address indexed retirer, string purpose, uint256 amount);
    event CreditListed(uint256 indexed listingId, uint256 indexed creditId, address indexed seller, uint256 price);
    event CreditPurchased(uint256 indexed listingId, address indexed buyer, uint256 amount, uint256 totalPrice);
    event VerifierAdded(address indexed verifier);
    event StandardApproved(string standard);
    event ProjectVerified(string indexed projectId, string standard);
    
    constructor() ERC20("Carbon Credit Token", "CCR") {
        _mint(msg.sender, INITIAL_SUPPLY);
        
        // Initialize approved standards
        approvedStandards["VCS"] = true;
        approvedStandards["Gold Standard"] = true;
        approvedStandards["CDM"] = true;
        approvedStandards["CAR"] = true;
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mint new carbon credits (only owner/verifiers)
     */
    function mint(address to, uint256 amount, string calldata reason) external override {
        require(owner() == msg.sender || verifiers[msg.sender], "CCR: Unauthorized");
        require(totalSupply() + amount <= MAX_SUPPLY, "CCR: Exceeds max supply");
        _mint(to, amount);
        emit TokensMinted(to, amount, reason);
    }
    
    /**
     * @dev Burn carbon credits (retirement)
     */
    function burn(address from, uint256 amount, string calldata reason) external override {
        require(owner() == msg.sender || verifiers[msg.sender], "CCR: Unauthorized");
        _burn(from, amount);
        emit TokensBurned(from, amount, reason);
    }
    
    // ============ CARBON CREDIT SYSTEM ============
    
    /**
     * @dev Issue new carbon credit
     */
    function issueCarbonCredit(
        string calldata projectId,
        string calldata standard,
        uint256 vintage,
        string calldata country,
        string calldata projectType,
        uint256 co2Reduction,
        address recipient
    ) external onlyOwner {
        require(approvedStandards[standard], "CCR: Standard not approved");
        require(co2Reduction > 0, "CCR: Invalid CO2 reduction amount");
        
        uint256 creditId = creditCount++;
        carbonCredits[creditId] = CarbonCredit({
            id: creditId,
            projectId: projectId,
            standard: standard,
            vintage: vintage,
            country: country,
            projectType: projectType,
            co2Reduction: co2Reduction,
            verified: true,
            retired: false,
            issuer: msg.sender,
            issueDate: block.timestamp,
            retirementDate: 0
        });
        
        userCredits[recipient].push(creditId);
        _mint(recipient, co2Reduction * 10**18);
        
        emit CarbonCreditIssued(creditId, msg.sender, projectId, co2Reduction);
    }
    
    /**
     * @dev Retire carbon credits
     */
    function retireCarbonCredit(
        uint256 creditId,
        string calldata purpose,
        string calldata certificate
    ) external nonReentrant {
        CarbonCredit storage credit = carbonCredits[creditId];
        require(credit.verified, "CCR: Credit not verified");
        require(!credit.retired, "CCR: Credit already retired");
        require(balanceOf(msg.sender) >= credit.co2Reduction * 10**18, "CCR: Insufficient balance");
        
        // Mark as retired
        credit.retired = true;
        credit.retirementDate = block.timestamp;
        
        // Create retirement record
        uint256 retirementId = retirementCount++;
        retirements[retirementId] = Retirement({
            creditId: creditId,
            retirer: msg.sender,
            purpose: purpose,
            amount: credit.co2Reduction,
            timestamp: block.timestamp,
            certificate: certificate
        });
        
        userRetirements[msg.sender].push(retirementId);
        
        // Burn tokens
        _burn(msg.sender, credit.co2Reduction * 10**18);
        
        emit CarbonCreditRetired(creditId, msg.sender, purpose, credit.co2Reduction);
    }
    
    /**
     * @dev Get user's carbon credits
     */
    function getUserCredits(address user) external view returns (uint256[] memory) {
        return userCredits[user];
    }
    
    /**
     * @dev Get user's retirements
     */
    function getUserRetirements(address user) external view returns (uint256[] memory) {
        return userRetirements[user];
    }
    
    // ============ MARKETPLACE SYSTEM ============
    
    /**
     * @dev List carbon credit for sale
     */
    function listCreditForSale(
        uint256 creditId,
        uint256 pricePerTon
    ) external nonReentrant {
        CarbonCredit storage credit = carbonCredits[creditId];
        require(credit.verified, "CCR: Credit not verified");
        require(!credit.retired, "CCR: Credit retired");
        require(pricePerTon > 0, "CCR: Invalid price");
        
        uint256 listingId = listingCount++;
        listings[listingId] = Listing({
            id: listingId,
            creditId: creditId,
            seller: msg.sender,
            price: pricePerTon,
            amount: credit.co2Reduction,
            active: true,
            listingDate: block.timestamp
        });
        
        userListings[msg.sender].push(listingId);
        
        emit CreditListed(listingId, creditId, msg.sender, pricePerTon);
    }
    
    /**
     * @dev Purchase carbon credit from marketplace
     */
    function purchaseCredit(uint256 listingId) external payable nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.active, "CCR: Listing not active");
        require(msg.value >= listing.price * listing.amount, "CCR: Insufficient payment");
        
        // Transfer credit to buyer
        userCredits[msg.sender].push(listing.creditId);
        userCredits[listing.seller].push(listing.creditId);
        
        // Transfer payment to seller
        payable(listing.seller).transfer(msg.value);
        
        // Deactivate listing
        listing.active = false;
        
        emit CreditPurchased(listingId, msg.sender, listing.amount, msg.value);
    }
    
    /**
     * @dev Cancel listing
     */
    function cancelListing(uint256 listingId) external {
        Listing storage listing = listings[listingId];
        require(listing.seller == msg.sender, "CCR: Not your listing");
        require(listing.active, "CCR: Listing not active");
        
        listing.active = false;
    }
    
    // ============ VERIFICATION SYSTEM ============
    
    /**
     * @dev Add verifier
     */
    function addVerifier(address verifier) external onlyOwner {
        verifiers[verifier] = true;
        emit VerifierAdded(verifier);
    }
    
    /**
     * @dev Remove verifier
     */
    function removeVerifier(address verifier) external onlyOwner {
        verifiers[verifier] = false;
    }
    
    /**
     * @dev Approve new standard
     */
    function approveStandard(string calldata standard) external onlyOwner {
        approvedStandards[standard] = true;
        emit StandardApproved(standard);
    }
    
    /**
     * @dev Verify project
     */
    function verifyProject(string calldata projectId, string calldata standard) external {
        require(verifiers[msg.sender], "CCR: Not a verifier");
        require(approvedStandards[standard], "CCR: Standard not approved");
        
        verifiedProjects[projectId] = true;
        emit ProjectVerified(projectId, standard);
    }
    
    // ============ SUSTAINABILITY SYSTEM ============
    
    /**
     * @dev Update sustainability score (not applicable for CCR)
     */
    function updateSustainabilityScore(address user, uint256 score) external override {
        // CCR doesn't use sustainability scores
        revert("CCR: Not applicable for carbon credits");
    }
    
    /**
     * @dev Get sustainability score (not applicable for CCR)
     */
    function getSustainabilityScore(address user) external view override returns (uint256) {
        // CCR doesn't use sustainability scores
        return 0;
    }
    
    /**
     * @dev Calculate ESG bonus (based on retirement history)
     */
    function calculateESGBonus(address user) external view override returns (uint256) {
        uint256[] memory userRetirementList = userRetirements[user];
        uint256 totalRetired = 0;
        
        for (uint256 i = 0; i < userRetirementList.length; i++) {
            totalRetired += retirements[userRetirementList[i]].amount;
        }
        
        // Bonus based on total CO2 retired
        if (totalRetired >= 1000) return 200; // 2x bonus for 1000+ tons
        if (totalRetired >= 500) return 150;  // 1.5x bonus for 500+ tons
        if (totalRetired >= 100) return 125; // 1.25x bonus for 100+ tons
        if (totalRetired >= 10) return 110;  // 1.1x bonus for 10+ tons
        return 100; // No bonus
    }
    
    // ============ GOVERNANCE SYSTEM ============
    
    /**
     * @dev Create proposal (simplified for CCR)
     */
    function createProposal(string calldata description, uint256 duration) external override returns (uint256) {
        require(balanceOf(msg.sender) >= 1000 * 10**18, "CCR: Insufficient tokens to propose");
        // Simplified governance for carbon credits
        return 0;
    }
    
    /**
     * @dev Vote on proposal (simplified for CCR)
     */
    function voteOnProposal(uint256 proposalId, bool support) external override {
        // Simplified governance for carbon credits
    }
    
    /**
     * @dev Get proposal votes (simplified for CCR)
     */
    function getProposalVotes(uint256 proposalId) external view override returns (uint256 forVotes, uint256 againstVotes) {
        return (0, 0);
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @dev Get carbon credit details
     */
    function getCarbonCredit(uint256 creditId) external view returns (CarbonCredit memory) {
        return carbonCredits[creditId];
    }
    
    /**
     * @dev Get marketplace statistics
     */
    function getMarketplaceStats() external view returns (
        uint256 totalListings,
        uint256 activeListings,
        uint256 totalRetirements,
        uint256 totalCreditsIssued
    ) {
        uint256 active = 0;
        for (uint256 i = 0; i < listingCount; i++) {
            if (listings[i].active) {
                active++;
            }
        }
        
        return (listingCount, active, retirementCount, creditCount);
    }
    
    /**
     * @dev Get user's carbon footprint
     */
    function getUserCarbonFootprint(address user) external view returns (
        uint256 totalCredits,
        uint256 totalRetired,
        uint256 availableForRetirement
    ) {
        uint256[] memory credits = userCredits[user];
        uint256[] memory userRetirementList = userRetirements[user];
        
        uint256 retired = 0;
        for (uint256 i = 0; i < userRetirementList.length; i++) {
            retired += retirements[userRetirementList[i]].amount;
        }
        
        return (credits.length, retired, balanceOf(user) / 10**18);
    }
}
