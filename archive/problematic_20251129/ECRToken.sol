// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title ECRToken - EcoCertificate Token (NFT)
 * @dev ERC721 token para certificados de sustentabilidade
 * @author ESG Token Ecosystem
 * 
 * Features:
 * - Certificados NFT de sustentabilidade
 * - Sistema de raridade
 * - Marketplace de certificados
 * - Verificação de autenticidade
 * - Integração com GST
 */
contract ECRToken is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, ReentrancyGuard {
    
    using Counters for Counters.Counter;
    
    // Token Configuration
    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 10_000_000; // 10 million certificates
    uint256 public constant INITIAL_SUPPLY = 1_000_000; // 1 million initial
    
    // Certificate System
    struct Certificate {
        uint256 id;
        string certificateType;
        string issuer;
        string standard;
        uint256 issueDate;
        uint256 expiryDate;
        uint256 rarity;
        string metadata;
        bool verified;
        bool transferable;
        address owner;
    }
    
    mapping(uint256 => Certificate) public certificates;
    mapping(address => uint256[]) public userCertificates;
    mapping(string => bool) public approvedStandards;
    mapping(address => bool) public authorizedIssuers;
    
    // Rarity System
    enum Rarity { Common, Uncommon, Rare, Epic, Legendary, Mythic }
    mapping(Rarity => uint256) public rarityMultipliers;
    mapping(Rarity => string) public rarityNames;
    
    // Marketplace System
    struct Listing {
        uint256 id;
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
        uint256 listingDate;
    }
    
    mapping(uint256 => Listing) public listings;
    mapping(address => uint256[]) public userListings;
    Counters.Counter private _listingIdCounter;
    
    // Verification System
    mapping(uint256 => bool) public verifiedCertificates;
    mapping(string => bool) public verifiedIssuers;
    
    // Integration with GST
    address public gstToken;
    mapping(address => uint256) public gstRewards;
    
    // Events
    event CertificateIssued(uint256 indexed tokenId, address indexed issuer, string certificateType, uint256 rarity);
    event CertificateVerified(uint256 indexed tokenId, address indexed verifier);
    event CertificateListed(uint256 indexed listingId, uint256 indexed tokenId, address indexed seller, uint256 price);
    event CertificatePurchased(uint256 indexed listingId, address indexed buyer, uint256 price);
    event RarityUpdated(uint256 indexed tokenId, uint256 newRarity);
    event GSTRewardEarned(address indexed user, uint256 amount);
    event IssuerAuthorized(address indexed issuer);
    event StandardApproved(string standard);
    
    constructor() ERC721("EcoCertificate", "ECR") {
        _initializeRaritySystem();
        _initializeApprovedStandards();
    }
    
    // ============ INITIALIZATION ============
    
    /**
     * @dev Initialize rarity system
     */
    function _initializeRaritySystem() internal {
        rarityMultipliers[Rarity.Common] = 100;
        rarityMultipliers[Rarity.Uncommon] = 150;
        rarityMultipliers[Rarity.Rare] = 200;
        rarityMultipliers[Rarity.Epic] = 300;
        rarityMultipliers[Rarity.Legendary] = 500;
        rarityMultipliers[Rarity.Mythic] = 1000;
        
        rarityNames[Rarity.Common] = "Common";
        rarityNames[Rarity.Uncommon] = "Uncommon";
        rarityNames[Rarity.Rare] = "Rare";
        rarityNames[Rarity.Epic] = "Epic";
        rarityNames[Rarity.Legendary] = "Legendary";
        rarityNames[Rarity.Mythic] = "Mythic";
    }
    
    /**
     * @dev Initialize approved standards
     */
    function _initializeApprovedStandards() internal {
        approvedStandards["ISO 14001"] = true;
        approvedStandards["LEED"] = true;
        approvedStandards["BREEAM"] = true;
        approvedStandards["Green Building"] = true;
        approvedStandards["Carbon Neutral"] = true;
        approvedStandards["Renewable Energy"] = true;
        approvedStandards["Sustainable Agriculture"] = true;
        approvedStandards["Eco-Friendly"] = true;
    }
    
    // ============ CERTIFICATE SYSTEM ============
    
    /**
     * @dev Issue new certificate
     */
    function issueCertificate(
        address to,
        string calldata certificateType,
        string calldata standard,
        uint256 expiryDate,
        string calldata metadata,
        Rarity rarity
    ) external onlyAuthorizedIssuer returns (uint256) {
        require(approvedStandards[standard], "ECR: Standard not approved");
        require(expiryDate > block.timestamp, "ECR: Invalid expiry date");
        require(_tokenIdCounter.current() < MAX_SUPPLY, "ECR: Max supply reached");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        certificates[tokenId] = Certificate({
            id: tokenId,
            certificateType: certificateType,
            issuer: msg.sender,
            standard: standard,
            issueDate: block.timestamp,
            expiryDate: expiryDate,
            rarity: uint256(rarity),
            metadata: metadata,
            verified: false,
            transferable: true,
            owner: to
        });
        
        userCertificates[to].push(tokenId);
        _safeMint(to, tokenId);
        
        emit CertificateIssued(tokenId, msg.sender, certificateType, uint256(rarity));
        return tokenId;
    }
    
    /**
     * @dev Verify certificate
     */
    function verifyCertificate(uint256 tokenId) external onlyOwner {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        
        certificates[tokenId].verified = true;
        verifiedCertificates[tokenId] = true;
        
        emit CertificateVerified(tokenId, msg.sender);
    }
    
    /**
     * @dev Get certificate details
     */
    function getCertificate(uint256 tokenId) external view returns (Certificate memory) {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        return certificates[tokenId];
    }
    
    /**
     * @dev Get user certificates
     */
    function getUserCertificates(address user) external view returns (uint256[] memory) {
        return userCertificates[user];
    }
    
    // ============ RARITY SYSTEM ============
    
    /**
     * @dev Update certificate rarity
     */
    function updateRarity(uint256 tokenId, Rarity newRarity) external onlyOwner {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        
        certificates[tokenId].rarity = uint256(newRarity);
        emit RarityUpdated(tokenId, uint256(newRarity));
    }
    
    /**
     * @dev Get rarity multiplier
     */
    function getRarityMultiplier(uint256 tokenId) external view returns (uint256) {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        Rarity rarity = Rarity(certificates[tokenId].rarity);
        return rarityMultipliers[rarity];
    }
    
    /**
     * @dev Get rarity name
     */
    function getRarityName(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        Rarity rarity = Rarity(certificates[tokenId].rarity);
        return rarityNames[rarity];
    }
    
    // ============ MARKETPLACE SYSTEM ============
    
    /**
     * @dev List certificate for sale
     */
    function listCertificate(uint256 tokenId, uint256 price) external {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        require(ownerOf(tokenId) == msg.sender, "ECR: Not certificate owner");
        require(certificates[tokenId].transferable, "ECR: Certificate not transferable");
        require(price > 0, "ECR: Invalid price");
        
        uint256 listingId = _listingIdCounter.current();
        _listingIdCounter.increment();
        
        listings[listingId] = Listing({
            id: listingId,
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            active: true,
            listingDate: block.timestamp
        });
        
        userListings[msg.sender].push(listingId);
        
        emit CertificateListed(listingId, tokenId, msg.sender, price);
    }
    
    /**
     * @dev Purchase certificate
     */
    function purchaseCertificate(uint256 listingId) external payable nonReentrant {
        Listing storage listing = listings[listingId];
        require(listing.active, "ECR: Listing not active");
        require(msg.value >= listing.price, "ECR: Insufficient payment");
        
        // Transfer certificate
        _transfer(listing.seller, msg.sender, listing.tokenId);
        
        // Update user certificates
        userCertificates[msg.sender].push(listing.tokenId);
        
        // Transfer payment
        payable(listing.seller).transfer(msg.value);
        
        // Deactivate listing
        listing.active = false;
        
        emit CertificatePurchased(listingId, msg.sender, msg.value);
    }
    
    /**
     * @dev Cancel listing
     */
    function cancelListing(uint256 listingId) external {
        Listing storage listing = listings[listingId];
        require(listing.seller == msg.sender, "ECR: Not your listing");
        require(listing.active, "ECR: Listing not active");
        
        listing.active = false;
    }
    
    // ============ GST INTEGRATION ============
    
    /**
     * @dev Set GST token address
     */
    function setGSTToken(address _gstToken) external onlyOwner {
        gstToken = _gstToken;
    }
    
    /**
     * @dev Earn GST rewards based on certificates
     */
    function earnGSTRewards(address user) external {
        require(msg.sender == gstToken, "ECR: Only GST token can call this");
        
        uint256[] memory userCerts = userCertificates[user];
        uint256 totalRewards = 0;
        
        for (uint256 i = 0; i < userCerts.length; i++) {
            uint256 tokenId = userCerts[i];
            if (certificates[tokenId].verified) {
                Rarity rarity = Rarity(certificates[tokenId].rarity);
                totalRewards += rarityMultipliers[rarity];
            }
        }
        
        gstRewards[user] += totalRewards;
        emit GSTRewardEarned(user, totalRewards);
    }
    
    /**
     * @dev Claim GST rewards
     */
    function claimGSTRewards() external {
        uint256 rewards = gstRewards[msg.sender];
        require(rewards > 0, "ECR: No rewards to claim");
        
        gstRewards[msg.sender] = 0;
        // Transfer rewards through GST token integration
    }
    
    // ============ ADMIN FUNCTIONS ============
    
    /**
     * @dev Authorize issuer
     */
    function authorizeIssuer(address issuer) external onlyOwner {
        authorizedIssuers[issuer] = true;
        emit IssuerAuthorized(issuer);
    }
    
    /**
     * @dev Approve standard
     */
    function approveStandard(string calldata standard) external onlyOwner {
        approvedStandards[standard] = true;
        emit StandardApproved(standard);
    }
    
    /**
     * @dev Set certificate transferability
     */
    function setTransferability(uint256 tokenId, bool transferable) external onlyOwner {
        require(_exists(tokenId), "ECR: Certificate does not exist");
        certificates[tokenId].transferable = transferable;
    }
    
    // ============ MODIFIERS ============
    
    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender] || msg.sender == owner(), "ECR: Not authorized issuer");
        _;
    }
    
    // ============ OVERRIDES ============
    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        require(certificates[tokenId].transferable, "ECR: Certificate not transferable");
        super._beforeTokenTransfer(from, to, tokenId);
    }
    
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    
    // ============ VIEW FUNCTIONS ============
    
    /**
     * @dev Get marketplace statistics
     */
    function getMarketplaceStats() external view returns (
        uint256 totalListings,
        uint256 activeListings,
        uint256 totalCertificates,
        uint256 verifiedCount
    ) {
        uint256 active = 0;
        uint256 verified = 0;
        
        for (uint256 i = 0; i < _listingIdCounter.current(); i++) {
            if (listings[i].active) {
                active++;
            }
        }
        
        for (uint256 i = 0; i < _tokenIdCounter.current(); i++) {
            if (verifiedCertificates[i]) {
                verified++;
            }
        }
        
        return (_listingIdCounter.current(), active, _tokenIdCounter.current(), verified);
    }
    
    /**
     * @dev Get user's certificate portfolio
     */
    function getUserPortfolio(address user) external view returns (
        uint256 totalCertificates,
        uint256 verifiedCount,
        uint256 totalRarity,
        uint256 gstRewardAmount
    ) {
        uint256[] memory userCerts = userCertificates[user];
        uint256 verified = 0;
        uint256 totalRarity_ = 0;
        
        for (uint256 i = 0; i < userCerts.length; i++) {
            uint256 tokenId = userCerts[i];
            if (certificates[tokenId].verified) {
                verified++;
            }
            totalRarity_ += certificates[tokenId].rarity;
        }
        
        return (userCerts.length, verified, totalRarity_, gstRewards[user]);
    }
}
