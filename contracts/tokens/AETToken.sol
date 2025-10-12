// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title AETToken - AI Ethics Token
 * @dev ERC20 token para incentivar práticas éticas em IA
 * @author ESG Token Ecosystem
 *
 * Features:
 * - TOKEN ESPECÍFICO para IA Ética
 * - Sistema de scoring ético integrado
 * - Green AI incentives
 * - Transparency & bias detection rewards
 * - Human-aligned AI bonuses
 * - Cross-platform integration
 */
contract AETToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ReentrancyGuard {

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

    // Green AI Metrics
    struct GreenAIMetrics {
        uint256 energyConsumption;     // kWh
        uint256 carbonFootprint;       // kg CO2
        uint256 renewableEnergyUsage;   // percentage
        uint256 efficiencyScore;       // 0-1000
        uint256 lastUpdate;            // timestamp
    }

    // Transparency & Bias Metrics
    struct TransparencyMetrics {
        uint256 explainabilityScore;   // 0-1000
        uint256 biasDetectionScore;    // 0-1000
        uint256 dataPrivacyScore;      // 0-1000
        uint256 humanOversightScore;   // 0-1000
        uint256 totalScore;            // 0-1000
        uint256 lastUpdate;            // timestamp
    }

    // User AI Ethics Profiles
    mapping(address => AIEthicsScore) public userEthicsScores;
    mapping(address => GreenAIMetrics) public userGreenAIMetrics;
    mapping(address => TransparencyMetrics) public userTransparencyMetrics;
    mapping(address => uint256) public totalAIEthicsRewards;
    mapping(address => uint256) public lastEthicsUpdate;

    // AI Ethics Achievements
    mapping(address => string[]) public userAchievements;
    mapping(address => uint256) public achievementCount;

    // AI Ethics Challenges
    struct AIEthicsChallenge {
        string name;
        string description;
        uint256 targetScore;
        uint256 rewardAmount;
        bool active;
        uint256 deadline;
    }

    mapping(uint256 => AIEthicsChallenge) public challenges;
    uint256 public nextChallengeId;
    mapping(address => mapping(uint256 => bool)) public userChallengeCompleted;

    // AI Ethics Events
    event AIEthicsScoreUpdated(address indexed user, uint256 totalScore, uint256 timestamp);
    event GreenAIMetricsUpdated(address indexed user, uint256 efficiencyScore, uint256 timestamp);
    event TransparencyMetricsUpdated(address indexed user, uint256 totalScore, uint256 timestamp);
    event AIEthicsRewardsClaimed(address indexed user, uint256 amount, string reason);
    event AchievementUnlocked(address indexed user, string achievement, uint256 timestamp);
    event ChallengeCompleted(address indexed user, uint256 challengeId, uint256 reward);
    event AIEthicsBonusCalculated(address indexed user, uint256 bonus, uint256 score);

    constructor() ERC20("AI Ethics Token", "AET") Ownable(msg.sender) {
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

    /**
     * @dev Pause token transfers
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpause token transfers
     */
    function unpause() public onlyOwner {
        _unpause();
    }

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

    /**
     * @dev Update Green AI Metrics for a user
     */
    function updateGreenAIMetrics(
        address user,
        uint256 energyConsumption,
        uint256 carbonFootprint,
        uint256 renewableEnergyUsage
    ) external onlyOwner {
        // Calculate efficiency score
        uint256 energyScore = energyConsumption > 0 ? (1000 - (energyConsumption / 100)) : 1000;
        uint256 carbonScore = carbonFootprint > 0 ? (1000 - (carbonFootprint / 10)) : 1000;
        uint256 renewableScore = renewableEnergyUsage * 10;
        
        uint256 efficiencyScore = (energyScore + carbonScore + renewableScore) / 3;

        userGreenAIMetrics[user] = GreenAIMetrics({
            energyConsumption: energyConsumption,
            carbonFootprint: carbonFootprint,
            renewableEnergyUsage: renewableEnergyUsage,
            efficiencyScore: efficiencyScore,
            lastUpdate: block.timestamp
        });

        emit GreenAIMetricsUpdated(user, efficiencyScore, block.timestamp);

        // Calculate and distribute rewards
        _calculateAndDistributeRewards(user, efficiencyScore);
    }

    /**
     * @dev Update Transparency Metrics for a user
     */
    function updateTransparencyMetrics(
        address user,
        uint256 explainabilityScore,
        uint256 biasDetectionScore,
        uint256 dataPrivacyScore,
        uint256 humanOversightScore
    ) external onlyOwner {
        require(explainabilityScore <= 1000, "AET: Explainability score exceeds max");
        require(biasDetectionScore <= 1000, "AET: Bias detection score exceeds max");
        require(dataPrivacyScore <= 1000, "AET: Data privacy score exceeds max");
        require(humanOversightScore <= 1000, "AET: Human oversight score exceeds max");

        uint256 totalScore = (explainabilityScore + biasDetectionScore + 
                             dataPrivacyScore + humanOversightScore) / 4;

        userTransparencyMetrics[user] = TransparencyMetrics({
            explainabilityScore: explainabilityScore,
            biasDetectionScore: biasDetectionScore,
            dataPrivacyScore: dataPrivacyScore,
            humanOversightScore: humanOversightScore,
            totalScore: totalScore,
            lastUpdate: block.timestamp
        });

        emit TransparencyMetricsUpdated(user, totalScore, block.timestamp);

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

    // ============ CHALLENGES SYSTEM ============

    /**
     * @dev Create a new AI Ethics Challenge
     */
    function createChallenge(
        string calldata name,
        string calldata description,
        uint256 targetScore,
        uint256 rewardAmount,
        uint256 deadline
    ) external onlyOwner {
        uint256 challengeId = nextChallengeId++;
        
        challenges[challengeId] = AIEthicsChallenge({
            name: name,
            description: description,
            targetScore: targetScore,
            rewardAmount: rewardAmount,
            active: true,
            deadline: deadline
        });
    }

    /**
     * @dev Complete a challenge
     */
    function completeChallenge(uint256 challengeId) external {
        AIEthicsChallenge storage challenge = challenges[challengeId];
        require(challenge.active, "AET: Challenge not active");
        require(block.timestamp <= challenge.deadline, "AET: Challenge expired");
        require(!userChallengeCompleted[msg.sender][challengeId], "AET: Challenge already completed");

        // Check if user meets the target score
        AIEthicsScore memory userScore = userEthicsScores[msg.sender];
        require(userScore.totalScore >= challenge.targetScore, "AET: Score not sufficient");

        // Mark as completed and reward
        userChallengeCompleted[msg.sender][challengeId] = true;
        _mint(msg.sender, challenge.rewardAmount);
        totalAIEthicsRewards[msg.sender] += challenge.rewardAmount;

        emit ChallengeCompleted(msg.sender, challengeId, challenge.rewardAmount);
    }

    // ============ VIEW FUNCTIONS ============

    /**
     * @dev Get user's AI Ethics profile
     */
    function getUserAIEthicsProfile(address user) external view returns (
        AIEthicsScore memory ethicsScore,
        GreenAIMetrics memory greenMetrics,
        TransparencyMetrics memory transparencyMetrics,
        uint256 totalRewards,
        uint256 achievementCount_,
        string[] memory achievements
    ) {
        return (
            userEthicsScores[user],
            userGreenAIMetrics[user],
            userTransparencyMetrics[user],
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
        uint256 initialSupply_,
        uint256 totalChallenges,
        uint256 activeChallenges
    ) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < nextChallengeId; i++) {
            if (challenges[i].active && block.timestamp <= challenges[i].deadline) {
                activeCount++;
            }
        }

        return (
            totalSupply(),
            MAX_SUPPLY,
            INITIAL_SUPPLY,
            nextChallengeId,
            activeCount
        );
    }

    // ============ OVERRIDES ============

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        require(!paused(), "ERC20Pausable: token transfer while paused");
        super._update(from, to, value);
    }
}
