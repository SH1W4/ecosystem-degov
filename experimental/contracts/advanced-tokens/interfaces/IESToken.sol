// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IESToken - EcoStake Token Interface
 * @dev Interface para o token de staking avançado
 * @author ESG Token Ecosystem
 */
interface IESToken {
    // Staking Functions
    function stake(uint256 amount) external;
    function unstake(uint256 amount) external;
    function claimRewards() external;
    function calculateRewards(address user) external view returns (uint256);
    
    // Staking Information
    function getStakingTier(address user) external view returns (uint32);
    function getTotalStaked() external view returns (uint256);
    function getStakedBalance(address user) external view returns (uint256);
    function getRewardRate(uint32 tier) external view returns (uint256);
    function getMinStakeAmount(uint32 tier) external view returns (uint256);
    
    // Events
    event TokensStaked(address indexed user, uint256 amount, uint256 tier);
    event TokensUnstaked(address indexed user, uint256 amount, uint256 rewards);
    event RewardsClaimed(address indexed user, uint256 amount);
    event StakingTierUpdated(address indexed user, uint32 newTier);
}


