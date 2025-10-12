// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IESToken.sol";

/**
 * @title ECTToken - EcoToken (Principal Token)
 * @dev ERC20 token principal do ecossistema ESG
 * @author ESG Token Ecosystem
 * 
 * Features:
 * - Token principal do ecossistema
 * - Sistema de staking integrado
 * - Recompensas por sustentabilidade
 * - Governança descentralizada
 * - Integração com outros tokens ESG
 */
contract ECTToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ReentrancyGuard, IESToken {
    
    // Token Configuration
    uint256 public constant MAX_SUPPLY = 10_000_000_000 * 10**18; // 10 billion ECT
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10**18; // 1 billion ECT initial
    
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
    uint256 public constant MIN_STAKE_AMOUNT = 1000 * 10**18; // 1000 ECT
    uint256 public constant MAX_STAKE_DURATION = 365 days; // 1 year max
    uint256 public constant MIN_STAKE_DURATION = 7 days; // 1 week min
    uint256 public constant BASE_APY = 10; // 10% base APY
    uint256 public constant SUSTAINABILITY_BONUS = 5; // 5% bonus for high sustainability
    
    // Sustainability Integration
    mapping(address => uint256) public sustainabilityScores;
    mapping(address => uint256) public lastScoreUpdate;
    uint256 public constant MAX_SCORE = 1000;
    
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
    uint256 public constant VOTING_DURATION = 5 days;
    uint256 public constant MIN_PROPOSAL_THRESHOLD = 10000 * 10**18; // 10,000 ECT
    uint256 public constant QUORUM_THRESHOLD = 100000 * 10**18; // 100,000 ECT
    
    // Cross-Token Integration
    mapping(address => bool) public authorizedTokens;
    mapping(address => uint256) public crossTokenRewards;
    
    // Events
    event TokensStaked(address indexed user, uint256 amount, uint256 duration, uint256 stakeId);
    event TokensUnstaked(address indexed user, uint256 stakeId, uint256 amount, uint256 rewards);
    event RewardsClaimed(address indexed user, uint256 amount);
    event SustainabilityScoreUpdated(address indexed user, uint256 newScore);
    event CrossTokenReward(address indexed user, address indexed token, uint256 amount);
    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, string description);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed proposalId);
    
    constructor() ERC20("EcoToken", "ECT") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
    
    // ============ CORE TOKEN FUNCTIONS ============
    
    /**
     * @dev Mint new tokens (only owner)
     */
    function mint(address to, uint256 amount, string calldata reason) external override onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "ECT: Exceeds max supply");
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
        require(balanceOf(msg.sender) - totalStaked[msg.sender] >= amount, "ECT: Insufficient unstaked balance");
        return super.transfer(to, amount);
    }
    
    // ============ STAKING SYSTEM ============
    
    /**
     * @dev Stake tokens for rewards
     */
    function stakeTokens(uint256 amount, uint256 duration) external nonReentrant {
        require(amount >= MIN_STAKE_AMOUNT, "ECT: Amount below minimum");
        require(duration >= MIN_STAKE_DURATION && duration <= MAX_STAKE_DURATION, "ECT: Invalid duration");
        require(balanceOf(msg.sender) >= amount, "ECT: Insufficient balance");
        
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
        require(stakeId < userStakes[msg.sender].length, "ECT: Invalid stake ID");
        StakeInfo storage stake = userStakes[msg.sender][stakeId];
        require(stake.active, "ECT: Stake not active");
        require(block.timestamp >= stake.startTime + stake.duration, "ECT: Stake not mature");
        
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
            apy += SUSTAINABILITY_BONUS;
        }
        
        // Calculate rewards based on time and APY
        uint256 annualReward = (stake.amount * apy) / 100;
        uint256 timeReward = (annualReward * timeStaked) / 365 days;
        
        return timeReward;
    }
    
    /**
     * @dev Get user's staking information
     */
    function getUserStakes(address user) external view returns (StakeInfo[] memory) {
        return userStakes[user];
    }
    
    // ============ SUSTAINABILITY SYSTEM ============
    
    /**
     * @dev Update sustainability score for a user
     */
    function updateSustainabilityScore(address user, uint256 score) external override onlyOwner {
        require(score <= MAX_SCORE, "ECT: Score exceeds maximum");
        sustainabilityScores[user] = score;
        lastScoreUpdate[user] = block.timestamp;
        emit SustainabilityScoreUpdated(user, score);
    }
    
    /**
     * @dev Get current sustainability score
     */
    function getSustainabilityScore(address user) external view override returns (uint256) {
        return sustainabilityScores[user];
    }
    
    /**
     * @dev Calculate ESG bonus based on sustainability score
     */
    function calculateESGBonus(address user) external view override returns (uint256) {
        uint256 score = sustainabilityScores[user];
        if (score >= 900) return 200; // 2x bonus
        if (score >= 800) return 150; // 1.5x bonus
        if (score >= 700) return 125; // 1.25x bonus
        if (score >= 600) return 110; // 1.1x bonus
        return 100; // No bonus
    }
    
    // ============ CROSS-TOKEN INTEGRATION ============
    
    /**
     * @dev Authorize another ESG token for cross-rewards
     */
    function authorizeToken(address token) external onlyOwner {
        authorizedTokens[token] = true;
    }
    
    /**
     * @dev Add cross-token rewards
     */
    function addCrossTokenReward(address user, address token, uint256 amount) external {
        require(authorizedTokens[msg.sender], "ECT: Unauthorized token");
        crossTokenRewards[user] += amount;
        emit CrossTokenReward(user, token, amount);
    }
    
    /**
     * @dev Claim cross-token rewards
     */
    function claimCrossTokenRewards() external {
        uint256 rewards = crossTokenRewards[msg.sender];
        require(rewards > 0, "ECT: No rewards to claim");
        
        crossTokenRewards[msg.sender] = 0;
        _mint(msg.sender, rewards);
        emit RewardsClaimed(msg.sender, rewards);
    }
    
    // ============ GOVERNANCE SYSTEM ============
    
    /**
     * @dev Create a new governance proposal
     */
    function createProposal(string calldata description, uint256 duration) external override returns (uint256) {
        require(balanceOf(msg.sender) >= MIN_PROPOSAL_THRESHOLD, "ECT: Insufficient tokens to propose");
        require(duration > 0 && duration <= 7 days, "ECT: Invalid duration");
        
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
        require(proposal.endTime > 0, "ECT: Proposal does not exist");
        require(block.timestamp <= proposal.endTime, "ECT: Voting period ended");
        require(!hasVoted[proposalId][msg.sender], "ECT: Already voted");
        
        uint256 weight = balanceOf(msg.sender) + totalStaked[msg.sender];
        require(weight > 0, "ECT: No voting power");
        
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
        require(proposal.endTime > 0, "ECT: Proposal does not exist");
        require(block.timestamp > proposal.endTime, "ECT: Voting period not ended");
        require(!proposal.executed, "ECT: Proposal already executed");
        require(proposal.forVotes > proposal.againstVotes, "ECT: Proposal did not pass");
        require(proposal.forVotes + proposal.againstVotes >= proposal.requiredQuorum, "ECT: Quorum not met");
        
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    /**
     * @dev Pause token transfers (emergency only)
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause token transfers
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    // ============ OVERRIDES ============
    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
    
    // ============ VIEW FUNCTIONS ============
    
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
     * @dev Get comprehensive user profile
     */
    function getUserProfile(address user) external view returns (
        uint256 balance,
        uint256 staked,
        uint256 sustainabilityScore,
        uint256 pendingRewards,
        uint256 crossTokenRewardAmount
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
            crossTokenRewards[user]
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
