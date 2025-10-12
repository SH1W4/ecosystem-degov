// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SimpleAETToken - AI Ethics Token (Simplified)
 * @dev ERC20 token simplificado para incentivar práticas éticas em IA
 * @author ESG Token Ecosystem
 */
contract SimpleAETToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {

    // Token Configuration
    uint256 public constant MAX_SUPPLY = 500_000_000 * 10**18; // 500 million AET
    uint256 public constant INITIAL_SUPPLY = 50_000_000 * 10**18; // 50 million AET initial

    // AI Ethics Scoring System
    struct AIEthicsScore {
        uint256 transparency;        // 0-1000 (25% weight)
        uint256 biasDetection;      // 0-1000 (25% weight)
        uint256 humanAlignment;     // 0-1000 (25% weight)
        uint256 environmentalImpact; // 0-1000 (25% weight)
        uint256 totalScore;        // 0-1000
        uint256 lastUpdate;        // timestamp
    }

    // User AI Ethics Profiles
    mapping(address => AIEthicsScore) public userEthicsScores;
    mapping(address => uint256) public totalAIEthicsRewards;
    mapping(address => uint256) public lastEthicsUpdate;

    // AI Ethics Achievements
    mapping(address => string[]) public userAchievements;
    mapping(address => uint256) public achievementCount;

    // AI Ethics Events
    event AIEthicsScoreUpdated(address indexed user, uint256 totalScore, uint256 timestamp);
    event AIEthicsRewardsClaimed(address indexed user, uint256 amount, string reason);
    event AchievementUnlocked(address indexed user, string achievement, uint256 timestamp);
    event AIEthicsBonusCalculated(address indexed user, uint256 bonus, uint256 score);

    constructor() ERC20("AI Ethics Token", "AET") Ownable() {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    // ============ CORE TOKEN FUNCTIONS ============

    /**
     * @dev Mint new AET tokens (only owner)
     */
    function mint(address to, uint256 amount, string calldata reason) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "AET: Exceeds max supply");
        _mint(to, amount);
        emit AIEthicsRewardsClaimed(to, amount, reason);
    }

    /**
     * @dev Burn AET tokens from any address (only owner)
     */
    function burn(address from, uint256 amount, string calldata reason) external onlyOwner {
        _burn(from, amount);
        emit AIEthicsRewardsClaimed(from, amount, reason);
    }

    // Pause functionality removed for simplicity

    // ============ AI ETHICS SCORING SYSTEM ============

    /**
     * @dev Update AI Ethics Score for a user
     */
    function updateAIEthicsScore(
        address user,
        uint256 transparency,
        uint256 biasDetection,
        uint256 humanAlignment,
        uint256 environmentalImpact
    ) external onlyOwner {
        require(transparency <= 1000, "AET: Transparency score exceeds max");
        require(biasDetection <= 1000, "AET: Bias detection score exceeds max");
        require(humanAlignment <= 1000, "AET: Human alignment score exceeds max");
        require(environmentalImpact <= 1000, "AET: Environmental impact score exceeds max");

        // Calculate total score (weighted average)
        uint256 totalScore = (transparency * 25 + biasDetection * 25 + 
                            humanAlignment * 25 + environmentalImpact * 25) / 100;

        userEthicsScores[user] = AIEthicsScore({
            transparency: transparency,
            biasDetection: biasDetection,
            humanAlignment: humanAlignment,
            environmentalImpact: environmentalImpact,
            totalScore: totalScore,
            lastUpdate: block.timestamp
        });

        lastEthicsUpdate[user] = block.timestamp;
        emit AIEthicsScoreUpdated(user, totalScore, block.timestamp);

        // Calculate and distribute rewards
        _calculateAndDistributeRewards(user, totalScore);
    }

    // ============ REWARDS SYSTEM ============

    /**
     * @dev Calculate and distribute rewards based on AI ethics score
     */
    function _calculateAndDistributeRewards(address user, uint256 score) internal {
        uint256 baseReward = 10; // 10 AET base reward
        uint256 scoreMultiplier = score / 1000;
        uint256 bonusMultiplier = 1;

        // Bonus for high scores
        if (score >= 900) {
            bonusMultiplier = 3; // 3x bonus for excellent scores
        } else if (score >= 800) {
            bonusMultiplier = 2; // 2x bonus for good scores
        } else if (score >= 700) {
            bonusMultiplier = 1; // 1x for average scores
        }

        uint256 totalReward = (baseReward * scoreMultiplier * bonusMultiplier);
        
        if (totalReward > 0) {
            _mint(user, totalReward);
            totalAIEthicsRewards[user] += totalReward;
            emit AIEthicsBonusCalculated(user, totalReward, score);
        }
    }

    // ============ ACHIEVEMENTS SYSTEM ============

    /**
     * @dev Unlock achievement for a user
     */
    function unlockAchievement(address user, string calldata achievement) external onlyOwner {
        userAchievements[user].push(achievement);
        achievementCount[user]++;
        
        // Reward for achievement
        uint256 achievementReward = 50; // 50 AET for each achievement
        _mint(user, achievementReward);
        totalAIEthicsRewards[user] += achievementReward;
        
        emit AchievementUnlocked(user, achievement, block.timestamp);
        emit AIEthicsRewardsClaimed(user, achievementReward, "Achievement Unlocked");
    }

    // ============ VIEW FUNCTIONS ============

    /**
     * @dev Get user's AI Ethics profile
     */
    function getUserAIEthicsProfile(address user) external view returns (
        AIEthicsScore memory ethicsScore,
        uint256 totalRewards,
        uint256 achievementCount_,
        string[] memory achievements
    ) {
        return (
            userEthicsScores[user],
            totalAIEthicsRewards[user],
            achievementCount[user],
            userAchievements[user]
        );
    }

    /**
     * @dev Get AI Ethics ecosystem stats
     */
    function getAIEthicsEcosystemStats() external view returns (
        uint256 totalSupply_,
        uint256 maxSupply_,
        uint256 initialSupply_
    ) {
        return (
            totalSupply(),
            MAX_SUPPLY,
            INITIAL_SUPPLY
        );
    }

    // ============ OVERRIDES ============

    // Override removed for simplicity
}
