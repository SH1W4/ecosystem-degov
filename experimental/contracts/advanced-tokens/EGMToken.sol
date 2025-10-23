// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/IESToken.sol";

/**
 * @title EGMToken - EcoGem Token (Premium)
 * @dev ERC20 token premium para acesso VIP e benefícios exclusivos
 * @author ESG Token Ecosystem
 * 
 * Features:
 * - Token premium e VIP
 * - Acesso exclusivo
 * - Benefícios exclusivos
 * - Sistema VIP
 * - Queima anual
 * - Integração com GST
 */
contract EGMToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard, IESToken {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18; // 1 million EGM
    uint256 public constant INITIAL_SUPPLY = 100_000 * 10**18; // 100,000 EGM initial
    uint256 public constant ANNUAL_BURN_RATE = 5; // 5% annual burn
    
    // VIP System
    struct VIPLevel {
        uint256 level;
        string name;
        uint256 requiredAmount;
        uint256 benefits;
        uint256 multiplier;
        bool active;
    }
    
    mapping(address => VIPLevel) public userVIPLevels;
    mapping(address => uint256) public vipPoints;
    mapping(address => uint256) public lastBurnDate;
    
    VIPLevel[] public vipLevels;
    uint256 public constant MAX_VIP_LEVEL = 5;
    
    // Premium Features
    struct PremiumFeature {
        uint256 id;
        string name;
        string description;
        uint256 cost;
        bool active;
    }
    
    mapping(uint256 => PremiumFeature) public premiumFeatures;
    mapping(address => mapping(uint256 => bool)) public userPremiumAccess;
    uint256 public featureCount;
    
    // Exclusive Benefits
    struct ExclusiveBenefit {
        uint256 id;
        string name;
        string description;
        uint256 vipLevelRequired;
        uint256 discount;
        bool active;
    }
    
    mapping(uint256 => ExclusiveBenefit) public exclusiveBenefits;
    mapping(address => mapping(uint256 => bool)) public userBenefitAccess;
    uint256 public benefitCount;
    
    // Annual Burn System
    uint256 public lastBurnTimestamp;
    uint256 public constant BURN_INTERVAL = 365 days;
    
    // Integration with GST
    address public gstToken;
    mapping(address => uint256) public gstRewards;
    
    // Events
    event VIPLevelUpgraded(address indexed user, uint256 newLevel, string levelName);
    event PremiumFeaturePurchased(address indexed user, uint256 featureId, string featureName);
    event ExclusiveBenefitActivated(address indexed user, uint256 benefitId, string benefitName);
    event AnnualBurnExecuted(uint256 amount, uint256 timestamp);
    event GSTRewardEarned(address indexed user, uint256 amount);
    event VIPPointsEarned(address indexed user, uint256 points);
    event TokensMinted(address indexed to, uint256 amount, string reason);
    event TokensBurned(address indexed from, uint256 amount, string reason);
    
    constructor() ERC20("EcoGem Token", "EGM") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _initializeVIPLevels();
        _initializePremiumFeatures();
        _initializeExclusiveBenefits();
        lastBurnTimestamp = block.timestamp;
    }
    
    // ============ INITIALIZATION ============
    
    /**
     * @dev Initialize VIP levels
     */
    function _initializeVIPLevels() internal {
        vipLevels.push(VIPLevel(1, "Eco Bronze", 100 * 10**18, 1, 110, true));
        vipLevels.push(VIPLevel(2, "Eco Silver", 500 * 10**18, 2, 125, true));
        vipLevels.push(VIPLevel(3, "Eco Gold", 1000 * 10**18, 3, 150, true));
        vipLevels.push(VIPLevel(4, "Eco Platinum", 2500 * 10**18, 4, 200, true));
        vipLevels.push(VIPLevel(5, "Eco Diamond", 5000 * 10**18, 5, 300, true));
    }
    
    /**
     * @dev Initialize premium features
     */
    function _initializePremiumFeatures() internal {
        _addPremiumFeature("Eco Analytics", "Advanced sustainability analytics", 10 * 10**18);
        _addPremiumFeature("Carbon Tracking", "Real-time carbon footprint tracking", 25 * 10**18);
        _addPremiumFeature("ESG Reporting", "Automated ESG report generation", 50 * 10**18);
        _addPremiumFeature("Green Investment", "Access to green investment opportunities", 100 * 10**18);
        _addPremiumFeature("Eco Consultation", "Personal sustainability consultation", 200 * 10**18);
    }
    
    /**
     * @dev Initialize exclusive benefits
     */
    function _initializeExclusiveBenefits() internal {
        _addExclusiveBenefit("VIP Support", "Priority customer support", 1, 0);
        _addExclusiveBenefit("Exclusive Events", "Access to exclusive eco events", 2, 0);
        _addExclusiveBenefit("Premium Content", "Access to premium sustainability content", 3, 0);
        _addExclusiveBenefit("Eco Certification", "Free eco certification process", 4, 0);
        _addExclusiveBenefit("Ambassador Program", "Become an eco ambassador", 5, 0);
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mint new tokens (only owner)
     */
    function mint(address to, uint256 amount, string calldata reason) external override onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "EGM: Exceeds max supply");
        _mint(to, amount);
        emit TokensMinted(to, amount, reason);
    }
    
    /**
     * @dev Burn tokens from any address (only owner)
     */
    function burn(address from, uint256 amount, string calldata reason) external override onlyOwner {
        _burn(from, amount);
        emit TokensBurned(from, amount, reason);
    }
    
    /**
     * @dev Transfer tokens with VIP consideration
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        _updateVIPLevel(msg.sender);
        _updateVIPLevel(to);
        return super.transfer(to, amount);
    }
    
    // ============ VIP SYSTEM ============
    
    /**
     * @dev Update user's VIP level based on balance
     */
    function _updateVIPLevel(address user) internal {
        uint256 balance = balanceOf(user);
        uint256 newLevel = _calculateVIPLevel(balance);
        
        if (newLevel > 0 && newLevel != userVIPLevels[user].level) {
            userVIPLevels[user] = vipLevels[newLevel - 1];
            emit VIPLevelUpgraded(user, newLevel, vipLevels[newLevel - 1].name);
        }
    }
    
    /**
     * @dev Calculate VIP level based on balance
     */
    function _calculateVIPLevel(uint256 balance) internal view returns (uint256) {
        for (uint256 i = vipLevels.length; i > 0; i--) {
            if (balance >= vipLevels[i - 1].requiredAmount) {
                return i;
            }
        }
        return 0;
    }
    
    /**
     * @dev Get user's VIP level
     */
    function getUserVIPLevel(address user) external view returns (VIPLevel memory) {
        return userVIPLevels[user];
    }
    
    /**
     * @dev Earn VIP points
     */
    function earnVIPPoints(address user, uint256 points) external onlyOwner {
        vipPoints[user] += points;
        emit VIPPointsEarned(user, points);
    }
    
    // ============ PREMIUM FEATURES ============
    
    /**
     * @dev Purchase premium feature
     */
    function purchasePremiumFeature(uint256 featureId) external {
        require(featureId < featureCount, "EGM: Invalid feature ID");
        PremiumFeature memory feature = premiumFeatures[featureId];
        require(feature.active, "EGM: Feature not active");
        require(balanceOf(msg.sender) >= feature.cost, "EGM: Insufficient balance");
        require(!userPremiumAccess[msg.sender][featureId], "EGM: Already purchased");
        
        // Deduct cost
        _burn(msg.sender, feature.cost);
        
        // Grant access
        userPremiumAccess[msg.sender][featureId] = true;
        
        emit PremiumFeaturePurchased(msg.sender, featureId, feature.name);
    }
    
    /**
     * @dev Check premium feature access
     */
    function hasPremiumAccess(address user, uint256 featureId) external view returns (bool) {
        return userPremiumAccess[user][featureId];
    }
    
    /**
     * @dev Add new premium feature
     */
    function _addPremiumFeature(string memory name, string memory description, uint256 cost) internal {
        premiumFeatures[featureCount] = PremiumFeature({
            id: featureCount,
            name: name,
            description: description,
            cost: cost,
            active: true
        });
        featureCount++;
    }
    
    // ============ EXCLUSIVE BENEFITS ============
    
    /**
     * @dev Activate exclusive benefit
     */
    function activateExclusiveBenefit(uint256 benefitId) external {
        require(benefitId < benefitCount, "EGM: Invalid benefit ID");
        ExclusiveBenefit memory benefit = exclusiveBenefits[benefitId];
        require(benefit.active, "EGM: Benefit not active");
        require(userVIPLevels[msg.sender].level >= benefit.vipLevelRequired, "EGM: VIP level insufficient");
        require(!userBenefitAccess[msg.sender][benefitId], "EGM: Benefit already activated");
        
        userBenefitAccess[msg.sender][benefitId] = true;
        emit ExclusiveBenefitActivated(msg.sender, benefitId, benefit.name);
    }
    
    /**
     * @dev Check exclusive benefit access
     */
    function hasExclusiveBenefit(address user, uint256 benefitId) external view returns (bool) {
        return userBenefitAccess[user][benefitId];
    }
    
    /**
     * @dev Add new exclusive benefit
     */
    function _addExclusiveBenefit(string memory name, string memory description, uint256 vipLevelRequired, uint256 discount) internal {
        exclusiveBenefits[benefitCount] = ExclusiveBenefit({
            id: benefitCount,
            name: name,
            description: description,
            vipLevelRequired: vipLevelRequired,
            discount: discount,
            active: true
        });
        benefitCount++;
    }
    
    // ============ ANNUAL BURN SYSTEM ============
    
    /**
     * @dev Execute annual burn
     */
    function executeAnnualBurn() external onlyOwner {
        require(block.timestamp >= lastBurnTimestamp + BURN_INTERVAL, "EGM: Burn interval not reached");
        
        uint256 burnAmount = (totalSupply() * ANNUAL_BURN_RATE) / 100;
        require(burnAmount > 0, "EGM: No tokens to burn");
        
        // Burn tokens from owner's balance
        _burn(owner(), burnAmount);
        
        lastBurnTimestamp = block.timestamp;
        emit AnnualBurnExecuted(burnAmount, block.timestamp);
    }
    
    /**
     * @dev Get time until next burn
     */
    function getTimeUntilNextBurn() external view returns (uint256) {
        if (block.timestamp >= lastBurnTimestamp + BURN_INTERVAL) {
            return 0;
        }
        return (lastBurnTimestamp + BURN_INTERVAL) - block.timestamp;
    }
    
    // ============ SUSTAINABILITY SYSTEM ============
    
    /**
     * @dev Update sustainability score (not applicable for EGM)
     */
    function updateSustainabilityScore(address user, uint256 score) external override {
        // EGM doesn't use sustainability scores directly
        revert("EGM: Not applicable for premium token");
    }
    
    /**
     * @dev Get sustainability score (not applicable for EGM)
     */
    function getSustainabilityScore(address user) external view override returns (uint256) {
        // EGM doesn't use sustainability scores directly
        return 0;
    }
    
    /**
     * @dev Calculate ESG bonus based on VIP level
     */
    function calculateESGBonus(address user) external view override returns (uint256) {
        VIPLevel memory vipLevel = userVIPLevels[user];
        if (vipLevel.level == 0) return 100;
        
        return vipLevel.multiplier;
    }
    
    // ============ GST INTEGRATION ============
    
    /**
     * @dev Set GST token address
     */
    function setGSTToken(address _gstToken) external onlyOwner {
        gstToken = _gstToken;
    }
    
    /**
     * @dev Earn GST rewards based on VIP level
     */
    function earnGSTRewards(address user) external {
        require(msg.sender == gstToken, "EGM: Only GST token can call this");
        
        VIPLevel memory vipLevel = userVIPLevels[user];
        if (vipLevel.level == 0) return;
        
        uint256 reward = vipLevel.benefits * 1000; // Base reward
        gstRewards[user] += reward;
        
        emit GSTRewardEarned(user, reward);
    }
    
    /**
     * @dev Claim GST rewards
     */
    function claimGSTRewards() external {
        uint256 rewards = gstRewards[msg.sender];
        require(rewards > 0, "EGM: No rewards to claim");
        
        gstRewards[msg.sender] = 0;
        // Transfer rewards through GST token integration
    }
    
    // ============ GOVERNANCE SYSTEM ============
    
    /**
     * @dev Create proposal (simplified for EGM)
     */
    function createProposal(string calldata description, uint256 duration) external override returns (uint256) {
        require(balanceOf(msg.sender) >= 100 * 10**18, "EGM: Insufficient tokens to propose");
        // Simplified governance for EGM
        return 0;
    }
    
    /**
     * @dev Vote on proposal (simplified for EGM)
     */
    function voteOnProposal(uint256 proposalId, bool support) external override {
        // Simplified governance for EGM
    }
    
    /**
     * @dev Get proposal votes (simplified for EGM)
     */
    function getProposalVotes(uint256 proposalId) external view override returns (uint256 forVotes, uint256 againstVotes) {
        return (0, 0);
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @dev Get user's comprehensive profile
     */
    function getUserProfile(address user) external view returns (
        uint256 balance,
        uint256 vipLevel,
        uint256 vipPointAmount,
        uint256 premiumFeatureCount,
        uint256 exclusiveBenefitCount,
        uint256 gstRewardAmount
    ) {
        uint256 premiumCount = 0;
        uint256 benefitCount_ = 0;
        
        for (uint256 i = 0; i < featureCount; i++) {
            if (userPremiumAccess[user][i]) {
                premiumCount++;
            }
        }
        
        for (uint256 i = 0; i < benefitCount; i++) {
            if (userBenefitAccess[user][i]) {
                benefitCount_++;
            }
        }
        
        return (
            balanceOf(user),
            userVIPLevels[user].level,
            vipPoints[user],
            premiumCount,
            benefitCount_,
            gstRewards[user]
        );
    }
    
    /**
     * @dev Get premium feature information
     */
    function getPremiumFeature(uint256 featureId) external view returns (PremiumFeature memory) {
        return premiumFeatures[featureId];
    }
    
    /**
     * @dev Get exclusive benefit information
     */
    function getExclusiveBenefit(uint256 benefitId) external view returns (ExclusiveBenefit memory) {
        return exclusiveBenefits[benefitId];
    }
    
    /**
     * @dev Get ecosystem statistics
     */
    function getEcosystemStats() external view returns (
        uint256 totalSupply_,
        uint256 totalVIPUsers,
        uint256 totalPremiumFeatures,
        uint256 totalExclusiveBenefits,
        uint256 timeUntilNextBurn
    ) {
        uint256 vipUsers = 0;
        for (uint256 i = 0; i < vipLevels.length; i++) {
            // This would require tracking VIP users
            // Implementation depends on specific requirements
        }
        
        uint256 timeUntilBurn = 0;
        if (block.timestamp < lastBurnTimestamp + BURN_INTERVAL) {
            timeUntilBurn = (lastBurnTimestamp + BURN_INTERVAL) - block.timestamp;
        }
        
        return (
            totalSupply(),
            vipUsers,
            featureCount,
            benefitCount,
            timeUntilBurn
        );
    }
}
