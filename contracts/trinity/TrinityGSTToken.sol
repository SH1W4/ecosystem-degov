// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title TrinityGSTToken - "Bitcoin da Sustentabilidade"
 * @dev Token principal do ecossistema ESG + IA Ética
 * @author Trinity Architecture - Unindo Satoshi + Vitalik + Our Vision
 * 
 * SATOSHI APPROACH: Simplicidade + Descentralização + Confiança
 * VITALIK APPROACH: Flexibilidade + Programabilidade + Composabilidade  
 * OUR APPROACH: Impacto Real + Sustentabilidade + IA Ética
 */
contract TrinityGSTToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    
    // ============ SATOSHI PILLAR: SIMPLICITY & DECENTRALIZATION ============
    
    // Token Configuration (Simple like Bitcoin)
    uint256 public constant MAX_SUPPLY = 21_000_000 * 10**18; // 21 million GST (like Bitcoin)
    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 10**18; // 1 million GST initial
    
    // Trust Score System (0-1000, like Satoshi's simplicity)
    struct TrustScore {
        uint256 transparency;      // 0-1000 (25% weight)
        uint256 decentralization; // 0-1000 (25% weight) 
        uint256 security;         // 0-1000 (25% weight)
        uint256 impact;           // 0-1000 (25% weight)
        uint256 totalScore;       // 0-1000
        uint256 lastUpdate;       // timestamp
    }
    
    mapping(address => TrustScore) public userTrustScores;
    mapping(address => uint256) public totalTrustRewards;
    
    // ============ VITALIK PILLAR: FLEXIBILITY & PROGRAMMABILITY ============
    
    // Composable Token System
    mapping(address => bool) public isComposableToken;
    mapping(address => uint256) public composabilityScore;
    
    // Upgrade System (without breaking changes)
    uint256 public version = 1;
    mapping(uint256 => string) public versionNotes;
    
    // ============ OUR PILLAR: SUSTAINABILITY & AI ETHICS ============
    
    // ESG Impact Measurement
    struct ESGImpact {
        uint256 environmental; // 0-1000
        uint256 social;       // 0-1000
        uint256 governance;   // 0-1000
        uint256 aiEthics;    // 0-1000
        uint256 totalImpact;  // 0-1000
        uint256 lastUpdate;   // timestamp
    }
    
    mapping(address => ESGImpact) public userESGImpacts;
    mapping(address => uint256) public totalESGRewards;
    
    // AI Ethics Integration
    mapping(address => bool) public isAIEthicsVerified;
    mapping(address => uint256) public aiEthicsScore;
    
    // ============ EVENTS ============
    
    // Satoshi Events (Simple and Clear)
    event GSTMinted(address indexed to, uint256 amount);
    event GSTBurned(address indexed from, uint256 amount);
    event TrustScoreUpdated(address indexed user, uint256 newScore, uint256 timestamp);
    
    // Vitalik Events (Flexible and Programmable)
    event TokenComposed(address indexed token, bool composable);
    event VersionUpgraded(uint256 newVersion, string notes);
    event ComposabilityScoreUpdated(address indexed user, uint256 score);
    
    // Our Events (Impact and Ethics)
    event ESGImpactUpdated(address indexed user, uint256 environmental, uint256 social, uint256 governance, uint256 aiEthics);
    event AIEthicsVerified(address indexed user, uint256 score);
    event ESGRewardsClaimed(address indexed user, uint256 amount, string reason);
    
    // ============ CONSTRUCTOR ============
    
    constructor() ERC20("Trinity GST Token", "GST") Ownable() {
        // Mint initial supply (like Bitcoin's genesis block)
        _mint(msg.sender, INITIAL_SUPPLY);
        emit GSTMinted(msg.sender, INITIAL_SUPPLY);
    }
    
    // ============ SATOSHI PILLAR FUNCTIONS ============
    
    /**
     * @dev Mint new GST tokens (only owner, like Bitcoin's mining)
     * @param to Address to mint tokens to
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) public onlyOwner nonReentrant {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(to, amount);
        emit GSTMinted(to, amount);
    }
    
    /**
     * @dev Burn GST tokens (like Bitcoin's UTXO destruction)
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) public override nonReentrant {
        _burn(msg.sender, amount);
        emit GSTBurned(msg.sender, amount);
    }
    
    /**
     * @dev Calculate trust score (Satoshi's simplicity approach)
     * @param user Address of the user
     * @param transparency Transparency score (0-1000)
     * @param decentralization Decentralization score (0-1000)
     * @param security Security score (0-1000)
     * @param impact Impact score (0-1000)
     */
    function updateTrustScore(
        address user,
        uint256 transparency,
        uint256 decentralization,
        uint256 security,
        uint256 impact
    ) public onlyOwner nonReentrant {
        require(transparency <= 1000 && decentralization <= 1000 && 
                security <= 1000 && impact <= 1000, "Scores must be between 0 and 1000");
        
        uint256 totalScore = (transparency + decentralization + security + impact) / 4;
        
        userTrustScores[user] = TrustScore({
            transparency: transparency,
            decentralization: decentralization,
            security: security,
            impact: impact,
            totalScore: totalScore,
            lastUpdate: block.timestamp
        });
        
        emit TrustScoreUpdated(user, totalScore, block.timestamp);
        
        // Award trust rewards (like Bitcoin's block rewards)
        _awardTrustRewards(user, totalScore);
    }
    
    /**
     * @dev Internal function to award GST based on trust score
     */
    function _awardTrustRewards(address user, uint256 trustScore) internal {
        uint256 rewardAmount = 0;
        
        if (trustScore >= 900) {
            rewardAmount = 100 * 10**18; // 100 GST for excellent trust
        } else if (trustScore >= 800) {
            rewardAmount = 50 * 10**18;  // 50 GST for very good trust
        } else if (trustScore >= 700) {
            rewardAmount = 10 * 10**18;  // 10 GST for good trust
        }
        
        if (rewardAmount > 0) {
            mint(user, rewardAmount);
            totalTrustRewards[user] += rewardAmount;
        }
    }
    
    // ============ VITALIK PILLAR FUNCTIONS ============
    
    /**
     * @dev Set token as composable (Vitalik's flexibility)
     * @param token Address of the token
     * @param composable Whether the token is composable
     */
    function setComposableToken(address token, bool composable) public onlyOwner {
        isComposableToken[token] = composable;
        emit TokenComposed(token, composable);
    }
    
    /**
     * @dev Update composability score (Vitalik's programmability)
     * @param user Address of the user
     * @param score Composability score (0-1000)
     */
    function updateComposabilityScore(address user, uint256 score) public onlyOwner {
        require(score <= 1000, "Score must be between 0 and 1000");
        composabilityScore[user] = score;
        emit ComposabilityScoreUpdated(user, score);
    }
    
    /**
     * @dev Upgrade version (Vitalik's upgradeability)
     * @param newVersion New version number
     * @param notes Version notes
     */
    function upgradeVersion(uint256 newVersion, string memory notes) public onlyOwner {
        require(newVersion > version, "Version must be higher");
        version = newVersion;
        versionNotes[newVersion] = notes;
        emit VersionUpgraded(newVersion, notes);
    }
    
    // ============ OUR PILLAR FUNCTIONS ============
    
    /**
     * @dev Update ESG impact (Our sustainability approach)
     * @param user Address of the user
     * @param environmental Environmental score (0-1000)
     * @param social Social score (0-1000)
     * @param governance Governance score (0-1000)
     * @param aiEthics AI Ethics score (0-1000)
     */
    function updateESGImpact(
        address user,
        uint256 environmental,
        uint256 social,
        uint256 governance,
        uint256 aiEthics
    ) public onlyOwner nonReentrant {
        require(environmental <= 1000 && social <= 1000 && 
                governance <= 1000 && aiEthics <= 1000, "Scores must be between 0 and 1000");
        
        uint256 totalImpact = (environmental + social + governance + aiEthics) / 4;
        
        userESGImpacts[user] = ESGImpact({
            environmental: environmental,
            social: social,
            governance: governance,
            aiEthics: aiEthics,
            totalImpact: totalImpact,
            lastUpdate: block.timestamp
        });
        
        emit ESGImpactUpdated(user, environmental, social, governance, aiEthics);
        
        // Award ESG rewards
        _awardESGRewards(user, totalImpact);
    }
    
    /**
     * @dev Verify AI Ethics (Our AI ethics approach)
     * @param user Address of the user
     * @param score AI Ethics score (0-1000)
     */
    function verifyAIEthics(address user, uint256 score) public onlyOwner {
        require(score <= 1000, "Score must be between 0 and 1000");
        isAIEthicsVerified[user] = true;
        aiEthicsScore[user] = score;
        emit AIEthicsVerified(user, score);
    }
    
    /**
     * @dev Internal function to award GST based on ESG impact
     */
    function _awardESGRewards(address user, uint256 esgImpact) internal {
        uint256 rewardAmount = 0;
        
        if (esgImpact >= 900) {
            rewardAmount = 200 * 10**18; // 200 GST for excellent ESG impact
        } else if (esgImpact >= 800) {
            rewardAmount = 100 * 10**18; // 100 GST for very good ESG impact
        } else if (esgImpact >= 700) {
            rewardAmount = 50 * 10**18;  // 50 GST for good ESG impact
        }
        
        if (rewardAmount > 0) {
            mint(user, rewardAmount);
            totalESGRewards[user] += rewardAmount;
            emit ESGRewardsClaimed(user, rewardAmount, "ESG Impact Reward");
        }
    }
    
    // ============ TRINITY FUSION FUNCTIONS ============
    
    /**
     * @dev Get combined Trinity score (all 3 pillars)
     * @param user Address of the user
     * @return trinityScore Combined score from all 3 pillars
     */
    function getTrinityScore(address user) public view returns (uint256 trinityScore) {
        TrustScore memory trust = userTrustScores[user];
        ESGImpact memory esg = userESGImpacts[user];
        uint256 composability = composabilityScore[user];
        
        if (trust.lastUpdate == 0 || esg.lastUpdate == 0) {
            return 0;
        }
        
        // Trinity Score = (Trust + ESG + Composability) / 3
        trinityScore = (trust.totalScore + esg.totalImpact + composability) / 3;
    }
    
    /**
     * @dev Get user's complete Trinity profile
     * @param user Address of the user
     * @return trust Trust score details
     * @return esg ESG impact details
     * @return composability Composability score
     * @return trinityScore Combined Trinity score
     */
    function getTrinityProfile(address user) public view returns (
        TrustScore memory trust,
        ESGImpact memory esg,
        uint256 composability,
        uint256 trinityScore
    ) {
        trust = userTrustScores[user];
        esg = userESGImpacts[user];
        composability = composabilityScore[user];
        trinityScore = getTrinityScore(user);
    }
    
    // ============ ECOSYSTEM STATS ============
    
    /**
     * @dev Get Trinity Ecosystem statistics
     * @return totalSupply_ Current total supply
     * @return maxSupply_ Maximum possible supply
     * @return version_ Current version
     * @return composableTokens_ Number of composable tokens
     */
    function getTrinityEcosystemStats() public view returns (
        uint256 totalSupply_,
        uint256 maxSupply_,
        uint256 version_,
        uint256 composableTokens_
    ) {
        totalSupply_ = totalSupply();
        maxSupply_ = MAX_SUPPLY;
        version_ = version;
        // Note: composableTokens_ would need to be tracked separately
        composableTokens_ = 0; // Placeholder
    }
}
