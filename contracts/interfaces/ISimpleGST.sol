// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ISimpleGST - Interface for Simple GST Token
 * @dev Interface for the simplified GST token
 */
interface ISimpleGST {
    // Events
    event TokensStaked(address indexed user, uint256 amount, uint256 duration, uint256 stakeId);
    event TokensUnstaked(address indexed user, uint256 stakeId, uint256 amount, uint256 rewards);
    event SustainabilityScoreUpdated(address indexed user, uint256 newScore, uint256 timestamp);
    event TokensMinted(address indexed to, uint256 amount, string reason);
    event TokensBurned(address indexed from, uint256 amount, string reason);
    
    // Functions
    function mint(address to, uint256 amount, string calldata reason) external;
    function burn(address from, uint256 amount, string calldata reason) external;
    function stakeTokens(uint256 amount, uint256 duration) external;
    function unstakeTokens(uint256 stakeId) external;
    function calculateStakeRewards(address user, uint256 stakeId) external view returns (uint256);
    function updateSustainabilityScore(address user, uint256 score) external;
    function getSustainabilityScore(address user) external view returns (uint256);
    function getUserStakes(address user) external view returns (uint256[] memory);
    function getTotalStakingRewards(address user) external view returns (uint256);
    function getUserProfile(address user) external view returns (
        uint256 balance,
        uint256 staked,
        uint256 sustainabilityScore,
        uint256 pendingRewards,
        uint256 totalStakes
    );
    function getEcosystemStats() external view returns (
        uint256 totalSupply_,
        uint256 totalStaked_,
        uint256 maxSupply_,
        uint256 initialSupply_
    );
}
