// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title ECTToken - EcoToken
 * @dev ERC20 token para recompensas ESG e sustentabilidade
 * @author ESG Token Ecosystem
 */
contract ECTToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1 billion ECT
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 10**18; // 100 million ECT initial
    
    // ESG Integration
    address public gstToken; // Reference to GST Token
    address public esgOracle; // ESG data oracle
    
    // User ESG Profile
    struct UserESGProfile {
        uint256 sustainabilityScore; // 0-1000
        uint256 environmentalImpact; // 0-1000
        uint256 socialImpact; // 0-1000
        uint256 governanceScore; // 0-1000
        uint256 totalRewards; // Total ECT rewards earned
        uint256 lastUpdateTimestamp;
        uint256 achievementCount;
    }
    
    mapping(address => UserESGProfile) public userESGProfiles;
    mapping(address => mapping(string => bool)) public userAchievements;
    
    // ESG Rewards Configuration
    uint256 public baseRewardRate = 10 * 10**18; // 10 ECT base reward
    uint256 public sustainabilityMultiplier = 2; // 2x multiplier for high sustainability
    uint256 public environmentalMultiplier = 1.5 * 10**18; // 1.5x for environmental actions
    
    // Events
    event ECTMinted(address indexed to, uint256 amount, string reason);
    event ECTBurned(address indexed from, uint256 amount, string reason);
    event ESGScoreUpdated(address indexed user, uint256 sustainabilityScore, uint256 environmentalImpact, uint256 socialImpact, uint256 governanceScore);
    event ESGRewardsClaimed(address indexed user, uint256 amount, string reason);
    event AchievementUnlocked(address indexed user, string achievement, uint256 timestamp);
    event GSTTokenSet(address indexed gstToken);
    event ESGOracleSet(address indexed esgOracle);
    
    constructor() ERC20("EcoToken", "ECT") Ownable() {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mints new ECT tokens. Only callable by the owner.
     * @param to The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     * @param reason The reason for minting.
     */
    function mint(address to, uint256 amount, string memory reason) public onlyOwner nonReentrant {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
        emit ECTMinted(to, amount, reason);
    }
    
    /**
     * @dev Burns ECT tokens from a specified address.
     * @param from The address to burn tokens from.
     * @param amount The amount of tokens to burn.
     * @param reason The reason for burning.
     */
    function burn(address from, uint256 amount, string memory reason) external onlyOwner {
        _burn(from, amount);
        emit ECTBurned(from, amount, reason);
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
     * @dev Sets the ESG Oracle address for external ESG data.
     * @param _esgOracle The address of the ESG Oracle contract.
     */
    function setESGOracle(address _esgOracle) external onlyOwner {
        require(_esgOracle != address(0), "ESG Oracle address cannot be zero");
        esgOracle = _esgOracle;
        emit ESGOracleSet(_esgOracle);
    }
    
    // ============ ESG SCORING SYSTEM ============
    
    /**
     * @dev Updates ESG scores for a user.
     * @param user The address of the user.
     * @param sustainabilityScore Score for sustainability (0-1000).
     * @param environmentalImpact Score for environmental impact (0-1000).
     * @param socialImpact Score for social impact (0-1000).
     * @param governanceScore Score for governance (0-1000).
     */
    function updateESGScore(
        address user,
        uint256 sustainabilityScore,
        uint256 environmentalImpact,
        uint256 socialImpact,
        uint256 governanceScore
    ) public onlyOwner {
        require(sustainabilityScore <= 1000 && environmentalImpact <= 1000 &&
                socialImpact <= 1000 && governanceScore <= 1000,
                "Scores must be between 0 and 1000");
        
        userESGProfiles[user] = UserESGProfile({
            sustainabilityScore: sustainabilityScore,
            environmentalImpact: environmentalImpact,
            socialImpact: socialImpact,
            governanceScore: governanceScore,
            totalRewards: userESGProfiles[user].totalRewards, // Preserve existing rewards
            lastUpdateTimestamp: block.timestamp,
            achievementCount: userESGProfiles[user].achievementCount // Preserve existing achievements
        });
        
        emit ESGScoreUpdated(user, sustainabilityScore, environmentalImpact, socialImpact, governanceScore);
        
        // Calculate and award ESG rewards
        _calculateAndAwardESGRewards(user, sustainabilityScore, environmentalImpact, socialImpact, governanceScore);
    }
    
    /**
     * @dev Internal function to calculate and award ECT rewards based on ESG scores.
     * @param user The address of the user.
     * @param sustainabilityScore The sustainability score.
     * @param environmentalImpact The environmental impact score.
     * @param socialImpact The social impact score.
     * @param governanceScore The governance score.
     */
    function _calculateAndAwardESGRewards(
        address user,
        uint256 sustainabilityScore,
        uint256 environmentalImpact,
        uint256 socialImpact,
        uint256 governanceScore
    ) internal {
        uint256 totalReward = 0;
        string memory reason = "ESG Score Reward";
        
        // Base reward for any ESG activity
        totalReward += baseRewardRate;
        
        // Sustainability bonus (2x multiplier for high scores)
        if (sustainabilityScore >= 800) {
            uint256 sustainabilityBonus = (baseRewardRate * sustainabilityMultiplier) / 10**18;
            totalReward += sustainabilityBonus;
        }
        
        // Environmental impact bonus
        if (environmentalImpact >= 700) {
            uint256 environmentalBonus = (baseRewardRate * environmentalMultiplier) / 10**18;
            totalReward += environmentalBonus;
        }
        
        // Social impact bonus
        if (socialImpact >= 750) {
            uint256 socialBonus = baseRewardRate / 2; // 50% bonus
            totalReward += socialBonus;
        }
        
        // Governance bonus
        if (governanceScore >= 850) {
            uint256 governanceBonus = baseRewardRate / 4; // 25% bonus
            totalReward += governanceBonus;
        }
        
        if (totalReward > 0) {
            string memory rewardReason = "ESG Score Reward";
            mint(user, totalReward, rewardReason);
            userESGProfiles[user].totalRewards += totalReward;
            emit ESGRewardsClaimed(user, totalReward, rewardReason);
        }
    }
    
    /**
     * @dev Gets a user's ESG profile.
     * @param user The address of the user.
     * @return UserESGProfile The user's ESG profile.
     */
    function getUserESGProfile(address user) public view returns (UserESGProfile memory) {
        return userESGProfiles[user];
    }
    
    /**
     * @dev Calculates the combined ESG score for a user.
     * @param user The address of the user.
     * @return uint256 The combined ESG score (average of all scores).
     */
    function getCombinedESGScore(address user) public view returns (uint256) {
        UserESGProfile memory profile = userESGProfiles[user];
        if (profile.lastUpdateTimestamp == 0) {
            return 0; // No profile exists
        }
        return (profile.sustainabilityScore + profile.environmentalImpact + 
                profile.socialImpact + profile.governanceScore) / 4;
    }
    
    // ============ ACHIEVEMENTS SYSTEM ============
    
    /**
     * @dev Unlocks an achievement for a user.
     * @param user The address of the user.
     * @param achievementName The name of the achievement.
     */
    function unlockAchievement(address user, string memory achievementName) public onlyOwner {
        require(!userAchievements[user][achievementName], "Achievement already unlocked");
        
        userAchievements[user][achievementName] = true;
        userESGProfiles[user].achievementCount++;
        emit AchievementUnlocked(user, achievementName, block.timestamp);
        
        // Award achievement bonus
        uint256 achievementBonus = 5 * 10**18; // 5 ECT
        string memory achievementReason = "Achievement Bonus";
        mint(user, achievementBonus, achievementReason);
        userESGProfiles[user].totalRewards += achievementBonus;
    }
    
    /**
     * @dev Checks if a user has unlocked a specific achievement.
     * @param user The address of the user.
     * @param achievementName The name of the achievement.
     * @return bool True if the achievement is unlocked, false otherwise.
     */
    function hasAchievement(address user, string memory achievementName) public view returns (bool) {
        return userAchievements[user][achievementName];
    }
    
    // ============ ECOSYSTEM STATS ============
    
    /**
     * @dev Gets overall ESG Ecosystem statistics.
     * @return totalSupply_ Current total supply of ECT.
     * @return maxSupply_ Maximum possible supply of ECT.
     * @return initialSupply_ Initial supply of ECT.
     */
    function getESGEcosystemStats() public view returns (uint256 totalSupply_, uint256 maxSupply_, uint256 initialSupply_) {
        totalSupply_ = totalSupply();
        maxSupply_ = MAX_SUPPLY;
        initialSupply_ = INITIAL_SUPPLY;
    }
    
    // ============ CROSS-TOKEN INTEGRATION ============
    
    /**
     * @dev Converts ECT to GST tokens (if GST token is set).
     * @param amount The amount of ECT to convert.
     * @return bool True if conversion was successful.
     */
    function convertToGST(uint256 amount) external nonReentrant returns (bool) {
        require(gstToken != address(0), "GST Token not set");
        require(balanceOf(msg.sender) >= amount, "Insufficient ECT balance");
        
        // Burn ECT tokens
        _burn(msg.sender, amount);
        
        // Note: In a real implementation, this would interact with the GST token contract
        // to mint equivalent GST tokens. For now, we'll just emit an event.
        emit ECTBurned(msg.sender, amount, "Converted to GST");
        
        return true;
    }
}