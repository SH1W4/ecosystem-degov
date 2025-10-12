// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IESToken.sol";

/**
 * @title ECSToken - EcoScore Token
 * @dev ERC20 token para sistema de pontuação ESG
 * @author ESG Token Ecosystem
 * 
 * Features:
 * - Sistema de pontuação ESG
 * - Benefícios por nível
 * - Sistema de conquistas
 * - Integração com GST
 * - Gamificação avançada
 */
contract ECSToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard, IESToken {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18; // 100 million ECS
    uint256 public constant INITIAL_SUPPLY = 10_000_000 * 10**18; // 10 million ECS initial
    
    // Scoring System
    struct UserProfile {
        uint256 totalScore;
        uint256 currentLevel;
        uint256 lastUpdate;
        uint256 achievements;
        uint256 benefits;
        bool active;
    }
    
    mapping(address => UserProfile) public userProfiles;
    mapping(address => uint256[]) public userAchievements;
    mapping(address => uint256[]) public userBenefits;
    
    // Level System
    struct Level {
        uint256 level;
        string name;
        uint256 requiredScore;
        uint256 benefits;
        uint256 multiplier;
    }
    
    Level[] public levels;
    uint256 public constant MAX_LEVEL = 10;
    
    // Achievement System
    struct Achievement {
        uint256 id;
        string name;
        string description;
        uint256 requiredScore;
        uint256 reward;
        bool active;
    }
    
    mapping(uint256 => Achievement) public achievements;
    mapping(address => mapping(uint256 => bool)) public userAchievementStatus;
    uint256 public achievementCount;
    
    // Benefit System
    struct Benefit {
        uint256 id;
        string name;
        string description;
        uint256 levelRequired;
        uint256 discount;
        bool active;
    }
    
    mapping(uint256 => Benefit) public benefits;
    mapping(address => mapping(uint256 => bool)) public userBenefitStatus;
    uint256 public benefitCount;
    
    // Integration with GST
    address public gstToken;
    mapping(address => uint256) public gstRewards;
    
    // Events
    event ScoreUpdated(address indexed user, uint256 newScore, uint256 newLevel);
    event LevelUp(address indexed user, uint256 newLevel, string levelName);
    event AchievementUnlocked(address indexed user, uint256 achievementId, string achievementName);
    event BenefitActivated(address indexed user, uint256 benefitId, string benefitName);
    event GSTRewardEarned(address indexed user, uint256 amount);
    event ProfileCreated(address indexed user, uint256 initialScore);
    event TokensMinted(address indexed to, uint256 amount, string reason);
    event TokensBurned(address indexed from, uint256 amount, string reason);
    
    constructor() ERC20("EcoScore Token", "ECS") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _initializeLevels();
        _initializeAchievements();
        _initializeBenefits();
    }
    
    // ============ INITIALIZATION ============
    
    /**
     * @dev Initialize level system
     */
    function _initializeLevels() internal {
        levels.push(Level(1, "Eco Beginner", 100, 1, 100));
        levels.push(Level(2, "Green Enthusiast", 500, 2, 110));
        levels.push(Level(3, "Eco Warrior", 1000, 3, 125));
        levels.push(Level(4, "Sustainability Champion", 2500, 4, 150));
        levels.push(Level(5, "Eco Master", 5000, 5, 175));
        levels.push(Level(6, "Green Legend", 10000, 6, 200));
        levels.push(Level(7, "Eco Hero", 25000, 7, 250));
        levels.push(Level(8, "Sustainability Guru", 50000, 8, 300));
        levels.push(Level(9, "Eco Titan", 100000, 9, 400));
        levels.push(Level(10, "Green Deity", 250000, 10, 500));
    }
    
    /**
     * @dev Initialize achievements
     */
    function _initializeAchievements() internal {
        _addAchievement("First Steps", "Earn your first 100 points", 100, 50);
        _addAchievement("Green Thumb", "Reach 500 points", 500, 100);
        _addAchievement("Eco Warrior", "Reach 1000 points", 1000, 200);
        _addAchievement("Sustainability Champion", "Reach 2500 points", 2500, 500);
        _addAchievement("Eco Master", "Reach 5000 points", 5000, 1000);
        _addAchievement("Green Legend", "Reach 10000 points", 10000, 2000);
        _addAchievement("Eco Hero", "Reach 25000 points", 25000, 5000);
        _addAchievement("Sustainability Guru", "Reach 50000 points", 50000, 10000);
        _addAchievement("Eco Titan", "Reach 100000 points", 100000, 25000);
        _addAchievement("Green Deity", "Reach 250000 points", 250000, 50000);
    }
    
    /**
     * @dev Initialize benefits
     */
    function _initializeBenefits() internal {
        _addBenefit("Eco Discount", "5% discount on eco products", 1, 5);
        _addBenefit("Green Shipping", "Free eco-friendly shipping", 2, 0);
        _addBenefit("Premium Support", "Priority customer support", 3, 0);
        _addBenefit("Exclusive Access", "Access to exclusive eco products", 4, 0);
        _addBenefit("VIP Events", "Invitation to eco events", 5, 0);
        _addBenefit("Eco Consultation", "Free sustainability consultation", 6, 0);
        _addBenefit("Carbon Offset", "Free carbon offset credits", 7, 0);
        _addBenefit("Eco Certification", "Free eco certification", 8, 0);
        _addBenefit("Green Investment", "Access to green investment opportunities", 9, 0);
        _addBenefit("Eco Ambassador", "Become an eco ambassador", 10, 0);
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mint new tokens (only owner)
     */
    function mint(address to, uint256 amount, string calldata reason) external override onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "ECS: Exceeds max supply");
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
    
    // ============ SCORING SYSTEM ============
    
    /**
     * @dev Update user score
     */
    function updateScore(address user, uint256 score) external onlyOwner {
        require(score > 0, "ECS: Invalid score");
        
        UserProfile storage profile = userProfiles[user];
        
        // Create profile if doesn't exist
        if (!profile.active) {
            profile.active = true;
            profile.totalScore = 0;
            profile.currentLevel = 0;
            profile.lastUpdate = block.timestamp;
            profile.achievements = 0;
            profile.benefits = 0;
            emit ProfileCreated(user, score);
        }
        
        // Update score
        uint256 oldScore = profile.totalScore;
        profile.totalScore += score;
        profile.lastUpdate = block.timestamp;
        
        // Check for level up
        uint256 newLevel = _calculateLevel(profile.totalScore);
        if (newLevel > profile.currentLevel) {
            profile.currentLevel = newLevel;
            emit LevelUp(user, newLevel, levels[newLevel - 1].name);
        }
        
        // Check for achievements
        _checkAchievements(user);
        
        // Check for benefits
        _checkBenefits(user);
        
        emit ScoreUpdated(user, profile.totalScore, profile.currentLevel);
    }
    
    /**
     * @dev Calculate user level based on score
     */
    function _calculateLevel(uint256 score) internal view returns (uint256) {
        for (uint256 i = levels.length; i > 0; i--) {
            if (score >= levels[i - 1].requiredScore) {
                return i;
            }
        }
        return 0;
    }
    
    /**
     * @dev Check for new achievements
     */
    function _checkAchievements(address user) internal {
        UserProfile storage profile = userProfiles[user];
        
        for (uint256 i = 0; i < achievementCount; i++) {
            if (!userAchievementStatus[user][i] && 
                profile.totalScore >= achievements[i].requiredScore) {
                
                userAchievementStatus[user][i] = true;
                userAchievements[user].push(i);
                profile.achievements++;
                
                // Mint reward tokens
                if (achievements[i].reward > 0) {
                    _mint(user, achievements[i].reward);
                }
                
                emit AchievementUnlocked(user, i, achievements[i].name);
            }
        }
    }
    
    /**
     * @dev Check for new benefits
     */
    function _checkBenefits(address user) internal {
        UserProfile storage profile = userProfiles[user];
        
        for (uint256 i = 0; i < benefitCount; i++) {
            if (!userBenefitStatus[user][i] && 
                profile.currentLevel >= benefits[i].levelRequired) {
                
                userBenefitStatus[user][i] = true;
                userBenefits[user].push(i);
                profile.benefits++;
                
                emit BenefitActivated(user, i, benefits[i].name);
            }
        }
    }
    
    // ============ SUSTAINABILITY SYSTEM ============
    
    /**
     * @dev Update sustainability score (ECS specific)
     */
    function updateSustainabilityScore(address user, uint256 score) external override onlyOwner {
        // ECS uses its own scoring system
        _updateScore(user, score);
    }
    
    /**
     * @dev Internal function to update score
     */
    function _updateScore(address user, uint256 score) internal {
        require(score > 0, "ECS: Invalid score");
        
        UserProfile storage profile = userProfiles[user];
        
        // Create profile if doesn't exist
        if (!profile.active) {
            profile.active = true;
            profile.totalScore = 0;
            profile.currentLevel = 0;
            profile.lastUpdate = block.timestamp;
            profile.achievements = 0;
            profile.benefits = 0;
            emit ProfileCreated(user, score);
        }
        
        // Update score
        uint256 oldScore = profile.totalScore;
        profile.totalScore += score;
        profile.lastUpdate = block.timestamp;
        
        // Check for level up
        uint256 newLevel = _calculateLevel(profile.totalScore);
        if (newLevel > profile.currentLevel) {
            profile.currentLevel = newLevel;
            emit LevelUp(user, newLevel, levels[newLevel - 1].name);
        }
        
        // Check for achievements
        _checkAchievements(user);
        
        // Check for benefits
        _checkBenefits(user);
        
        emit ScoreUpdated(user, profile.totalScore, profile.currentLevel);
    }
    
    /**
     * @dev Get current sustainability score
     */
    function getSustainabilityScore(address user) external view override returns (uint256) {
        return userProfiles[user].totalScore;
    }
    
    /**
     * @dev Calculate ESG bonus based on level
     */
    function calculateESGBonus(address user) external view override returns (uint256) {
        UserProfile memory profile = userProfiles[user];
        if (profile.currentLevel == 0) return 100;
        
        return levels[profile.currentLevel - 1].multiplier;
    }
    
    // ============ GST INTEGRATION ============
    
    /**
     * @dev Set GST token address
     */
    function setGSTToken(address _gstToken) external onlyOwner {
        gstToken = _gstToken;
    }
    
    /**
     * @dev Earn GST rewards based on ECS score
     */
    function earnGSTRewards(address user) external {
        require(msg.sender == gstToken, "ECS: Only GST token can call this");
        
        UserProfile memory profile = userProfiles[user];
        if (profile.currentLevel == 0) return;
        
        uint256 reward = (profile.totalScore * levels[profile.currentLevel - 1].multiplier) / 10000;
        gstRewards[user] += reward;
        
        emit GSTRewardEarned(user, reward);
    }
    
    /**
     * @dev Claim GST rewards
     */
    function claimGSTRewards() external {
        uint256 rewards = gstRewards[msg.sender];
        require(rewards > 0, "ECS: No rewards to claim");
        
        gstRewards[msg.sender] = 0;
        // Transfer rewards through GST token integration
        // This would be implemented based on GST token interface
    }
    
    // ============ GOVERNANCE SYSTEM ============
    
    /**
     * @dev Create proposal (simplified for ECS)
     */
    function createProposal(string calldata description, uint256 duration) external override returns (uint256) {
        require(balanceOf(msg.sender) >= 1000 * 10**18, "ECS: Insufficient tokens to propose");
        // Simplified governance for ECS
        return 0;
    }
    
    /**
     * @dev Vote on proposal (simplified for ECS)
     */
    function voteOnProposal(uint256 proposalId, bool support) external override {
        // Simplified governance for ECS
    }
    
    /**
     * @dev Get proposal votes (simplified for ECS)
     */
    function getProposalVotes(uint256 proposalId) external view override returns (uint256 forVotes, uint256 againstVotes) {
        return (0, 0);
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    /**
     * @dev Add new achievement
     */
    function _addAchievement(string memory name, string memory description, uint256 requiredScore, uint256 reward) internal {
        achievements[achievementCount] = Achievement({
            id: achievementCount,
            name: name,
            description: description,
            requiredScore: requiredScore,
            reward: reward,
            active: true
        });
        achievementCount++;
    }
    
    /**
     * @dev Add new benefit
     */
    function _addBenefit(string memory name, string memory description, uint256 levelRequired, uint256 discount) internal {
        benefits[benefitCount] = Benefit({
            id: benefitCount,
            name: name,
            description: description,
            levelRequired: levelRequired,
            discount: discount,
            active: true
        });
        benefitCount++;
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @dev Get user profile
     */
    function getUserProfile(address user) external view returns (
        uint256 totalScore,
        uint256 currentLevel,
        uint256 userAchievementCount,
        uint256 userBenefitCount,
        uint256 gstRewardAmount
    ) {
        UserProfile memory profile = userProfiles[user];
        return (
            profile.totalScore,
            profile.currentLevel,
            profile.achievements,
            profile.benefits,
            gstRewards[user]
        );
    }
    
    /**
     * @dev Get user achievements
     */
    function getUserAchievements(address user) external view returns (uint256[] memory) {
        return userAchievements[user];
    }
    
    /**
     * @dev Get user benefits
     */
    function getUserBenefits(address user) external view returns (uint256[] memory) {
        return userBenefits[user];
    }
    
    /**
     * @dev Get level information
     */
    function getLevelInfo(uint256 level) external view returns (Level memory) {
        require(level > 0 && level <= levels.length, "ECS: Invalid level");
        return levels[level - 1];
    }
    
    /**
     * @dev Get achievement information
     */
    function getAchievementInfo(uint256 achievementId) external view returns (Achievement memory) {
        return achievements[achievementId];
    }
    
    /**
     * @dev Get benefit information
     */
    function getBenefitInfo(uint256 benefitId) external view returns (Benefit memory) {
        return benefits[benefitId];
    }
    
    /**
     * @dev Get ecosystem statistics
     */
    function getEcosystemStats() external view returns (
        uint256 totalUsers,
        uint256 totalAchievements,
        uint256 totalBenefits,
        uint256 averageScore
    ) {
        // This would require tracking total users and average score
        // Implementation depends on specific requirements
        return (0, achievementCount, benefitCount, 0);
    }
}
