// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IESToken.sol";

/**
 * @title ESTToken - EcoStake Token
 * @dev ERC20 token para sistema de staking avançado
 * @author ESG Token Ecosystem
 * 
 * Features:
 * - Sistema de staking com tiers
 * - Governança por stake
 * - Recompensas escalonadas
 * - Sistema de votação
 * - Integração com GST
 */
contract ESTToken is ERC20, ERC20Burnable, Ownable, ReentrancyGuard, IESToken {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 5_000_000_000 * 10**18; // 5 billion EST
    uint256 public constant INITIAL_SUPPLY = 500_000_000 * 10**18; // 500 million EST initial
    
    // Staking System
    struct StakeInfo {
        uint256 amount;
        uint256 startTime;
        uint256 duration;
        uint256 tier;
        uint256 rewards;
        bool active;
        bool locked;
    }
    
    mapping(address => StakeInfo[]) public userStakes;
    mapping(address => uint256) public totalStaked;
    uint256 public totalStakedSupply;
    
    // Tier System
    struct Tier {
        uint256 tier;
        string name;
        uint256 requiredAmount;
        uint256 apy;
        uint256 votingPower;
        uint256 benefits;
    }
    
    Tier[] public tiers;
    uint256 public constant MAX_TIERS = 10;
    
    // Staking Configuration
    uint256 public constant MIN_STAKE_AMOUNT = 1000 * 10**18; // 1000 EST
    uint256 public constant MAX_STAKE_DURATION = 730 days; // 2 years max
    uint256 public constant MIN_STAKE_DURATION = 30 days; // 1 month min
    
    // Governance System
    struct Proposal {
        uint256 id;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
        address proposer;
        uint256 requiredQuorum;
    }
    
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCount;
    uint256 public constant VOTING_DURATION = 7 days;
    uint256 public constant MIN_PROPOSAL_THRESHOLD = 10000 * 10**18; // 10,000 EST
    uint256 public constant QUORUM_THRESHOLD = 100000 * 10**18; // 100,000 EST
    
    // Lock System
    mapping(address => uint256) public lockPeriods;
    mapping(address => uint256) public lockEndTimes;
    
    // Integration with GST
    address public gstToken;
    mapping(address => uint256) public gstRewards;
    
    // Events
    event TokensStaked(address indexed user, uint256 amount, uint256 duration, uint256 tier, uint256 stakeId);
    event TokensUnstaked(address indexed user, uint256 stakeId, uint256 amount, uint256 rewards);
    event TierUpgraded(address indexed user, uint256 newTier, string tierName);
    event RewardsClaimed(address indexed user, uint256 amount);
    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, string description);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed proposalId);
    event TokensLocked(address indexed user, uint256 amount, uint256 lockPeriod);
    event TokensUnlocked(address indexed user, uint256 amount);
    event GSTRewardEarned(address indexed user, uint256 amount);
    event TokensMinted(address indexed to, uint256 amount, string reason);
    event TokensBurned(address indexed from, uint256 amount, string reason);
    
    constructor() ERC20("EcoStake Token", "EST") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _initializeTiers();
    }
    
    // ============ INITIALIZATION ============
    
    /**
     * @dev Initialize tier system
     */
    function _initializeTiers() internal {
        tiers.push(Tier(1, "Eco Starter", 1000 * 10**18, 5, 1, 1));
        tiers.push(Tier(2, "Green Member", 5000 * 10**18, 8, 2, 2));
        tiers.push(Tier(3, "Eco Supporter", 10000 * 10**18, 12, 3, 3));
        tiers.push(Tier(4, "Sustainability Advocate", 25000 * 10**18, 15, 4, 4));
        tiers.push(Tier(5, "Eco Champion", 50000 * 10**18, 18, 5, 5));
        tiers.push(Tier(6, "Green Leader", 100000 * 10**18, 22, 6, 6));
        tiers.push(Tier(7, "Eco Master", 250000 * 10**18, 25, 7, 7));
        tiers.push(Tier(8, "Sustainability Guru", 500000 * 10**18, 30, 8, 8));
        tiers.push(Tier(9, "Eco Titan", 1000000 * 10**18, 35, 9, 9));
        tiers.push(Tier(10, "Green Deity", 2500000 * 10**18, 40, 10, 10));
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mint new tokens (only owner)
     */
    function mint(address to, uint256 amount, string calldata reason) external override onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "EST: Exceeds max supply");
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
     * @dev Transfer tokens with staking consideration
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) - totalStaked[msg.sender] >= amount, "EST: Insufficient unstaked balance");
        return super.transfer(to, amount);
    }
    
    // ============ STAKING SYSTEM ============
    
    /**
     * @dev Stake EST tokens for rewards
     */
    function stakeTokens(uint256 amount, uint256 duration) external nonReentrant {
        require(amount >= MIN_STAKE_AMOUNT, "EST: Amount below minimum");
        require(duration >= MIN_STAKE_DURATION && duration <= MAX_STAKE_DURATION, "EST: Invalid duration");
        require(balanceOf(msg.sender) >= amount, "EST: Insufficient balance");
        
        // Calculate tier based on amount
        uint256 tier = _calculateTier(amount);
        
        // Create new stake
        uint256 stakeId = userStakes[msg.sender].length;
        userStakes[msg.sender].push(StakeInfo({
            amount: amount,
            startTime: block.timestamp,
            duration: duration,
            tier: tier,
            rewards: 0,
            active: true,
            locked: false
        }));
        
        totalStaked[msg.sender] += amount;
        totalStakedSupply += amount;
        
        emit TokensStaked(msg.sender, amount, duration, tier, stakeId);
    }
    
    /**
     * @dev Unstake tokens and claim rewards
     */
    function unstakeTokens(uint256 stakeId) external nonReentrant {
        require(stakeId < userStakes[msg.sender].length, "EST: Invalid stake ID");
        StakeInfo storage stake = userStakes[msg.sender][stakeId];
        require(stake.active, "EST: Stake not active");
        require(block.timestamp >= stake.startTime + stake.duration, "EST: Stake not mature");
        
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
        uint256 apy = tiers[stake.tier - 1].apy;
        
        // Calculate rewards based on time and APY
        uint256 annualReward = (stake.amount * apy) / 100;
        uint256 timeReward = (annualReward * timeStaked) / 365 days;
        
        return timeReward;
    }
    
    /**
     * @dev Calculate tier based on staked amount
     */
    function _calculateTier(uint256 amount) internal view returns (uint256) {
        for (uint256 i = tiers.length; i > 0; i--) {
            if (amount >= tiers[i - 1].requiredAmount) {
                return i;
            }
        }
        return 1; // Default to tier 1
    }
    
    /**
     * @dev Get user's current tier
     */
    function getUserTier(address user) external view returns (uint256) {
        return _calculateTier(totalStaked[user]);
    }
    
    /**
     * @dev Get tier information
     */
    function getTierInfo(uint256 tier) external view returns (Tier memory) {
        require(tier > 0 && tier <= tiers.length, "EST: Invalid tier");
        return tiers[tier - 1];
    }
    
    // ============ LOCK SYSTEM ============
    
    /**
     * @dev Lock tokens for governance
     */
    function lockTokens(uint256 amount, uint256 lockPeriod) external {
        require(balanceOf(msg.sender) >= amount, "EST: Insufficient balance");
        require(lockPeriod > 0, "EST: Invalid lock period");
        
        lockPeriods[msg.sender] = lockPeriod;
        lockEndTimes[msg.sender] = block.timestamp + lockPeriod;
        
        emit TokensLocked(msg.sender, amount, lockPeriod);
    }
    
    /**
     * @dev Unlock tokens after lock period
     */
    function unlockTokens() external {
        require(lockEndTimes[msg.sender] <= block.timestamp, "EST: Lock period not ended");
        
        uint256 amount = lockPeriods[msg.sender];
        lockPeriods[msg.sender] = 0;
        lockEndTimes[msg.sender] = 0;
        
        emit TokensUnlocked(msg.sender, amount);
    }
    
    // ============ SUSTAINABILITY SYSTEM ============
    
    /**
     * @dev Update sustainability score (not applicable for EST)
     */
    function updateSustainabilityScore(address user, uint256 score) external override {
        // EST doesn't use sustainability scores directly
        revert("EST: Not applicable for staking token");
    }
    
    /**
     * @dev Get sustainability score (not applicable for EST)
     */
    function getSustainabilityScore(address user) external view override returns (uint256) {
        // EST doesn't use sustainability scores directly
        return 0;
    }
    
    /**
     * @dev Calculate ESG bonus based on tier
     */
    function calculateESGBonus(address user) external view override returns (uint256) {
        uint256 tier = _calculateTier(totalStaked[user]);
        if (tier == 0) return 100;
        
        return tiers[tier - 1].benefits * 10; // Convert to percentage
    }
    
    // ============ GST INTEGRATION ============
    
    /**
     * @dev Set GST token address
     */
    function setGSTToken(address _gstToken) external onlyOwner {
        gstToken = _gstToken;
    }
    
    /**
     * @dev Earn GST rewards based on staking
     */
    function earnGSTRewards(address user) external {
        require(msg.sender == gstToken, "EST: Only GST token can call this");
        
        uint256 tier = _calculateTier(totalStaked[user]);
        if (tier == 0) return;
        
        uint256 reward = tiers[tier - 1].votingPower * 100; // Base reward
        gstRewards[user] += reward;
        
        emit GSTRewardEarned(user, reward);
    }
    
    /**
     * @dev Claim GST rewards
     */
    function claimGSTRewards() external {
        uint256 rewards = gstRewards[msg.sender];
        require(rewards > 0, "EST: No rewards to claim");
        
        gstRewards[msg.sender] = 0;
        // Transfer rewards through GST token integration
    }
    
    // ============ GOVERNANCE SYSTEM ============
    
    /**
     * @dev Create a new governance proposal
     */
    function createProposal(string calldata description, uint256 duration) external override returns (uint256) {
        require(balanceOf(msg.sender) >= MIN_PROPOSAL_THRESHOLD, "EST: Insufficient tokens to propose");
        require(duration > 0 && duration <= 14 days, "EST: Invalid duration");
        
        uint256 proposalId = proposalCount++;
        proposals[proposalId] = Proposal({
            id: proposalId,
            description: description,
            startTime: block.timestamp,
            endTime: block.timestamp + duration,
            forVotes: 0,
            againstVotes: 0,
            executed: false,
            proposer: msg.sender,
            requiredQuorum: QUORUM_THRESHOLD
        });
        
        emit ProposalCreated(proposalId, msg.sender, description);
        return proposalId;
    }
    
    /**
     * @dev Vote on a proposal
     */
    function voteOnProposal(uint256 proposalId, bool support) external override {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.endTime > 0, "EST: Proposal does not exist");
        require(block.timestamp <= proposal.endTime, "EST: Voting period ended");
        require(!hasVoted[proposalId][msg.sender], "EST: Already voted");
        
        uint256 weight = balanceOf(msg.sender) + totalStaked[msg.sender];
        require(weight > 0, "EST: No voting power");
        
        hasVoted[proposalId][msg.sender] = true;
        
        if (support) {
            proposal.forVotes += weight;
        } else {
            proposal.againstVotes += weight;
        }
        
        emit VoteCast(msg.sender, proposalId, support, weight);
    }
    
    /**
     * @dev Get proposal vote counts
     */
    function getProposalVotes(uint256 proposalId) external view override returns (uint256 forVotes, uint256 againstVotes) {
        Proposal memory proposal = proposals[proposalId];
        return (proposal.forVotes, proposal.againstVotes);
    }
    
    /**
     * @dev Execute a proposal if it passed
     */
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.endTime > 0, "EST: Proposal does not exist");
        require(block.timestamp > proposal.endTime, "EST: Voting period not ended");
        require(!proposal.executed, "EST: Proposal already executed");
        require(proposal.forVotes > proposal.againstVotes, "EST: Proposal did not pass");
        require(proposal.forVotes + proposal.againstVotes >= proposal.requiredQuorum, "EST: Quorum not met");
        
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
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
        uint256 tier,
        uint256 votingPower,
        uint256 pendingRewards,
        uint256 gstRewardAmount
    ) {
        uint256 userTier = _calculateTier(totalStaked[user]);
        uint256 votingPower_ = userTier > 0 ? tiers[userTier - 1].votingPower : 0;
        
        uint256 totalRewards = 0;
        for (uint256 i = 0; i < userStakes[user].length; i++) {
            if (userStakes[user][i].active) {
                totalRewards += calculateStakeRewards(user, i);
            }
        }
        
        return (
            balanceOf(user),
            totalStaked[user],
            userTier,
            votingPower_,
            totalRewards,
            gstRewards[user]
        );
    }
    
    /**
     * @dev Get ecosystem statistics
     */
    function getEcosystemStats() external view returns (
        uint256 totalSupply_,
        uint256 totalStaked_,
        uint256 totalProposals,
        uint256 activeProposals
    ) {
        uint256 active = 0;
        for (uint256 i = 0; i < proposalCount; i++) {
            if (!proposals[i].executed && block.timestamp <= proposals[i].endTime) {
                active++;
            }
        }
        
        return (totalSupply(), totalStakedSupply, proposalCount, active);
    }
}
