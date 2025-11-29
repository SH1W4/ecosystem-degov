// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SimpleGSTToken - Green Sustainability Token (Simplified for Testnet)
 * @dev ERC20 token principal do ecossistema ESG para sustentabilidade verde
 * @author ESG Token Ecosystem
 */
contract SimpleGSTToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18; // 1 billion GST
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 10**18; // 100 million GST initial
    
    // Staking System
    struct StakeInfo {
        uint256 amount;
        uint256 startTime;
        uint256 duration;
        uint256 rewards;
        bool active;
    }
    
    mapping(address => StakeInfo[]) public userStakes;
    mapping(address => uint256) public totalStaked;
    uint256 public totalStakedSupply;
    
    // Staking Configuration
    uint256 public constant MIN_STAKE_AMOUNT = 1000 * 10**18; // 1000 GST
    uint256 public constant MAX_STAKE_DURATION = 365 days; // 1 year max
    uint256 public constant MIN_STAKE_DURATION = 7 days; // 1 week min
    uint256 public constant BASE_APY = 15; // 15% base APY
    
    // Sustainability System
    mapping(address => uint256) public sustainabilityScores;
    mapping(address => uint256) public lastScoreUpdate;
    uint256 public constant MAX_SCORE = 1000;
    
    // Events
    event TokensStaked(address indexed user, uint256 amount, uint256 duration, uint256 stakeId);
    event TokensUnstaked(address indexed user, uint256 stakeId, uint256 amount, uint256 rewards);
    event SustainabilityScoreUpdated(address indexed user, uint256 newScore, uint256 timestamp);
    event TokensMinted(address indexed to, uint256 amount, string reason);
    event TokensBurned(address indexed from, uint256 amount, string reason);
    
    constructor() ERC20("Green Sustainability Token", "GST") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mint new tokens (only owner)
     */
    function mint(address to, uint256 amount, string calldata reason) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "GST: Exceeds max supply");
        _mint(to, amount);
        emit TokensMinted(to, amount, reason);
    }
    
    /**
     * @dev Burn tokens from any address (only owner)
     */
    function burn(address from, uint256 amount, string calldata reason) external onlyOwner {
        _burn(from, amount);
        emit TokensBurned(from, amount, reason);
    }
    
    /**
     * @dev Transfer tokens with staking consideration
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) - totalStaked[msg.sender] >= amount, "GST: Insufficient unstaked balance");
        return super.transfer(to, amount);
    }
    
    // ============ STAKING SYSTEM ============
    
    /**
     * @dev Stake GST tokens for rewards
     */
    function stakeTokens(uint256 amount, uint256 duration) external nonReentrant {
        require(amount >= MIN_STAKE_AMOUNT, "GST: Amount below minimum");
        require(duration >= MIN_STAKE_DURATION && duration <= MAX_STAKE_DURATION, "GST: Invalid duration");
        require(balanceOf(msg.sender) >= amount, "GST: Insufficient balance");
        
        // Create new stake
        uint256 stakeId = userStakes[msg.sender].length;
        userStakes[msg.sender].push(StakeInfo({
            amount: amount,
            startTime: block.timestamp,
            duration: duration,
            rewards: 0,
            active: true
        }));
        
        totalStaked[msg.sender] += amount;
        totalStakedSupply += amount;
        
        emit TokensStaked(msg.sender, amount, duration, stakeId);
    }
    
    /**
     * @dev Unstake tokens and claim rewards
     */
    function unstakeTokens(uint256 stakeId) external nonReentrant {
        require(stakeId < userStakes[msg.sender].length, "GST: Invalid stake ID");
        StakeInfo storage stake = userStakes[msg.sender][stakeId];
        require(stake.active, "GST: Stake not active");
        require(block.timestamp >= stake.startTime + stake.duration, "GST: Stake not mature");
        
        // Calculate rewards
        uint256 rewards = calculateStakeRewards(msg.sender, stakeId);
        stake.rewards = rewards;
        stake.active = false;
        
        // Update totals
        totalStaked[msg.sender] -= stake.amount;
        totalStakedSupply -= stake.amount;
        
        // Mint rewards
        if (rewards > 0) {
            _mint(msg.sender, rewards);
        }
        
        emit TokensUnstaked(msg.sender, stakeId, stake.amount, rewards);
    }
    
    /**
     * @dev Calculate rewards for a stake
     */
    function calculateStakeRewards(address user, uint256 stakeId) public view returns (uint256) {
        StakeInfo memory stake = userStakes[user][stakeId];
        if (!stake.active) return 0;
        
        uint256 timeStaked = block.timestamp - stake.startTime;
        uint256 apy = BASE_APY;
        
        // Add sustainability bonus
        if (sustainabilityScores[user] >= 800) {
            apy += 10; // 10% bonus
        }
        
        // Calculate rewards based on time and APY
        uint256 annualReward = (stake.amount * apy) / 100;
        uint256 timeReward = (annualReward * timeStaked) / 365 days;
        
        return timeReward;
    }
    
    // ============ SUSTAINABILITY SYSTEM ============
    
    /**
     * @dev Update sustainability score for a user
     */
    function updateSustainabilityScore(address user, uint256 score) external onlyOwner {
        require(score <= MAX_SCORE, "GST: Score exceeds maximum");
        sustainabilityScores[user] = score;
        lastScoreUpdate[user] = block.timestamp;
        emit SustainabilityScoreUpdated(user, score, block.timestamp);
    }
    
    /**
     * @dev Get current sustainability score
     */
    function getSustainabilityScore(address user) external view returns (uint256) {
        return sustainabilityScores[user];
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @dev Get user's staking information
     */
    function getUserStakes(address user) external view returns (StakeInfo[] memory) {
        return userStakes[user];
    }
    
    /**
     * @dev Get total staking rewards for user
     */
    function getTotalStakingRewards(address user) external view returns (uint256) {
        uint256 totalRewards = 0;
        for (uint256 i = 0; i < userStakes[user].length; i++) {
            if (userStakes[user][i].active) {
                totalRewards += calculateStakeRewards(user, i);
            }
        }
        return totalRewards;
    }
    
    /**
     * @dev Get user's comprehensive profile
     */
    function getUserProfile(address user) external view returns (
        uint256 balance,
        uint256 staked,
        uint256 sustainabilityScore,
        uint256 pendingRewards,
        uint256 totalStakes
    ) {
        uint256 totalRewards = 0;
        for (uint256 i = 0; i < userStakes[user].length; i++) {
            if (userStakes[user][i].active) {
                totalRewards += calculateStakeRewards(user, i);
            }
        }
        
        return (
            balanceOf(user),
            totalStaked[user],
            sustainabilityScores[user],
            totalRewards,
            userStakes[user].length
        );
    }
    
    /**
     * @dev Get ecosystem statistics
     */
    function getEcosystemStats() external view returns (
        uint256 totalSupply_,
        uint256 totalStaked_,
        uint256 maxSupply_,
        uint256 initialSupply_
    ) {
        return (totalSupply(), totalStakedSupply, MAX_SUPPLY, INITIAL_SUPPLY);
    }
}
