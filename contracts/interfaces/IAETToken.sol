// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IAETToken - AI Ethics Token Interface
 * @dev Interface para o token de IA Ética
 * @author ESG Token Ecosystem
 */
interface IAETToken {
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

    // AI Ethics Challenge
    struct AIEthicsChallenge {
        string name;
        string description;
        uint256 targetScore;
        uint256 rewardAmount;
        bool active;
        uint256 deadline;
    }

    // Events
    event AIEthicsScoreUpdated(address indexed user, uint256 totalScore, uint256 timestamp);
    event GreenAIMetricsUpdated(address indexed user, uint256 efficiencyScore, uint256 timestamp);
    event TransparencyMetricsUpdated(address indexed user, uint256 totalScore, uint256 timestamp);
    event AIEthicsRewardsClaimed(address indexed user, uint256 amount, string reason);
    event AchievementUnlocked(address indexed user, string achievement, uint256 timestamp);
    event ChallengeCompleted(address indexed user, uint256 challengeId, uint256 reward);
    event AIEthicsBonusCalculated(address indexed user, uint256 bonus, uint256 score);

    // Core Functions
    function updateAIEthicsScore(
        address user,
        uint256 transparency,
        uint256 biasDetection,
        uint256 humanAlignment,
        uint256 environmentalImpact
    ) external;

    function updateGreenAIMetrics(
        address user,
        uint256 energyConsumption,
        uint256 carbonFootprint,
        uint256 renewableEnergyUsage
    ) external;

    function updateTransparencyMetrics(
        address user,
        uint256 explainabilityScore,
        uint256 biasDetectionScore,
        uint256 dataPrivacyScore,
        uint256 humanOversightScore
    ) external;

    // Achievements
    function unlockAchievement(address user, string calldata achievement) external;

    // Challenges
    function createChallenge(
        string calldata name,
        string calldata description,
        uint256 targetScore,
        uint256 rewardAmount,
        uint256 deadline
    ) external;

    function completeChallenge(uint256 challengeId) external;

    // View Functions
    function getUserAIEthicsProfile(address user) external view returns (
        AIEthicsScore memory ethicsScore,
        GreenAIMetrics memory greenMetrics,
        TransparencyMetrics memory transparencyMetrics,
        uint256 totalRewards,
        uint256 achievementCount,
        string[] memory achievements
    );

    function getAIEthicsEcosystemStats() external view returns (
        uint256 totalSupply,
        uint256 maxSupply,
        uint256 initialSupply,
        uint256 totalChallenges,
        uint256 activeChallenges
    );
}
