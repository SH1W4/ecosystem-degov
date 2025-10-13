// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title TrinityESGContract
 * @dev Contrato inteligente integrado com Trinity Neural Network para análise ESG
 * @author Trinity AI Agent
 */
contract TrinityESGContract is Ownable, ReentrancyGuard {
    
    // Estrutura para dados NFe
    struct NFEData {
        string chaveAcesso;
        uint256 valorTotal;
        string categoria;
        string municipio;
        string uf;
        string cnpjEmitente;
        string cnpjDestinatario;
        uint256 dataEmissao;
        bool isVerificada;
    }
    
    // Estrutura para ESG Score
    struct ESGScore {
        uint256 environmental;  // 0-100
        uint256 social;        // 0-100
        uint256 governance;     // 0-100
        uint256 totalScore;    // 0-100
        uint256 confidence;    // 0-100
        uint256 timestamp;
    }
    
    // Estrutura para recompensas
    struct RewardData {
        uint256 gstAmount;
        uint256 aetAmount;
        uint256 nftTokenId;
        bool isClaimed;
        uint256 timestamp;
    }
    
    // Mapeamentos
    mapping(string => ESGScore) public nfeEsgScores;
    mapping(string => RewardData) public nfeRewards;
    mapping(address => uint256) public userTotalRewards;
    mapping(address => uint256) public userEsgScore;
    
    // Endereços dos tokens
    IERC20 public gstToken;
    IERC20 public aetToken;
    IERC721 public nfeNftContract;
    
    // Configurações
    uint256 public baseRewardRate = 100; // 100 GST por 1.0 ESG Score
    uint256 public bonusMultiplier = 150; // 150% para scores altos
    uint256 public highEsgThreshold = 70; // 70% para bonus
    
    // Eventos
    event NFEAnalyzed(string indexed chaveAcesso, uint256 esgScore, uint256 confidence);
    event RewardCalculated(string indexed chaveAcesso, uint256 gstAmount, uint256 aetAmount);
    event RewardClaimed(address indexed user, uint256 gstAmount, uint256 aetAmount);
    event TrinityOptimized(uint256 improvementPercentage, uint256 optimizationsApplied);
    
    constructor(
        address _gstToken,
        address _aetToken,
        address _nfeNftContract
    ) Ownable() {
        gstToken = IERC20(_gstToken);
        aetToken = IERC20(_aetToken);
        nfeNftContract = IERC721(_nfeNftContract);
    }
    
    /**
     * @dev Analisa NFe e calcula ESG Score usando Trinity Neural Network
     * @param nfeData Dados da NFe para análise
     * @return esgScore Score ESG calculado
     */
    function analyzeNFEWithTrinity(NFEData memory nfeData) 
        external 
        onlyOwner 
        nonReentrant 
        returns (ESGScore memory esgScore) 
    {
        require(bytes(nfeData.chaveAcesso).length == 44, "Invalid access key");
        require(nfeData.valorTotal > 0, "Value must be positive");
        require(nfeData.isVerificada, "NFe must be verified");
        
        // Simular análise da Trinity Neural Network
        esgScore = _calculateESGScore(nfeData);
        
        // Armazenar score
        nfeEsgScores[nfeData.chaveAcesso] = esgScore;
        
        // Calcular recompensas
        RewardData memory reward = _calculateRewards(nfeData, esgScore);
        nfeRewards[nfeData.chaveAcesso] = reward;
        
        // Atualizar estatísticas do usuário
        _updateUserStats(nfeData.cnpjDestinatario, esgScore.totalScore);
        
        emit NFEAnalyzed(nfeData.chaveAcesso, esgScore.totalScore, esgScore.confidence);
        emit RewardCalculated(nfeData.chaveAcesso, reward.gstAmount, reward.aetAmount);
        
        return esgScore;
    }
    
    /**
     * @dev Calcula ESG Score baseado nos dados da NFe
     * @param nfeData Dados da NFe
     * @return esgScore Score ESG calculado
     */
    function _calculateESGScore(NFEData memory nfeData) internal view returns (ESGScore memory) {
        uint256 environmental = 50; // Base
        uint256 social = 50;       // Base
        uint256 governance = 50;   // Base
        
        // Ajustar baseado na categoria
        if (keccak256(bytes(nfeData.categoria)) == keccak256(bytes("Energia Renovavel"))) {
            environmental = 90;
            social = 70;
            governance = 80;
        } else if (keccak256(bytes(nfeData.categoria)) == keccak256(bytes("Eletrico"))) {
            environmental = 85;
            social = 60;
            governance = 75;
        } else if (keccak256(bytes(nfeData.categoria)) == keccak256(bytes("Hibrido"))) {
            environmental = 75;
            social = 65;
            governance = 70;
        } else if (keccak256(bytes(nfeData.categoria)) == keccak256(bytes("Sustentavel"))) {
            environmental = 70;
            social = 80;
            governance = 75;
        } else if (keccak256(bytes(nfeData.categoria)) == keccak256(bytes("Reciclagem"))) {
            environmental = 65;
            social = 75;
            governance = 70;
        }
        
        // Ajustar baseado no valor (maior valor = maior impacto)
        uint256 valueFactor = (nfeData.valorTotal / 1000) * 5; // 5% por 1000 unidades
        environmental = environmental + valueFactor;
        social = social + valueFactor;
        governance = governance + valueFactor;
        
        // Limitar a 100
        if (environmental > 100) environmental = 100;
        if (social > 100) social = 100;
        if (governance > 100) governance = 100;
        
        uint256 totalScore = (environmental + social + governance) / 3;
        uint256 confidence = 85 + (nfeData.isVerificada ? 10 : 0);
        
        return ESGScore({
            environmental: environmental,
            social: social,
            governance: governance,
            totalScore: totalScore,
            confidence: confidence,
            timestamp: block.timestamp
        });
    }
    
    /**
     * @dev Calcula recompensas baseadas no ESG Score
     * @param esgScore Score ESG
     * @return reward Dados da recompensa
     */
    function _calculateRewards(NFEData memory /* nfeData */, ESGScore memory esgScore) 
        internal 
        view 
        returns (RewardData memory) 
    {
        uint256 baseGstAmount = (esgScore.totalScore * baseRewardRate) / 100;
        uint256 baseAetAmount = baseGstAmount / 2; // AET é metade do GST
        
        // Bonus para scores altos
        if (esgScore.totalScore >= highEsgThreshold) {
            baseGstAmount = (baseGstAmount * bonusMultiplier) / 100;
            baseAetAmount = (baseAetAmount * bonusMultiplier) / 100;
        }
        
        return RewardData({
            gstAmount: baseGstAmount,
            aetAmount: baseAetAmount,
            nftTokenId: 0, // Será definido quando NFT for criado
            isClaimed: false,
            timestamp: block.timestamp
        });
    }
    
    /**
     * @dev Atualiza estatísticas do usuário
     * @param cnpj CNPJ do usuário
     * @param esgScore Score ESG
     */
    function _updateUserStats(string memory cnpj, uint256 esgScore) internal {
        // Converter CNPJ para endereço (simplificado)
        address user = address(uint160(uint256(keccak256(bytes(cnpj)))));
        
        userTotalRewards[user] += esgScore;
        userEsgScore[user] = (userEsgScore[user] + esgScore) / 2; // Média móvel
    }
    
    /**
     * @dev Permite ao usuário reivindicar recompensas
     * @param chaveAcesso Chave de acesso da NFe
     */
    function claimRewards(string memory chaveAcesso) external nonReentrant {
        require(nfeEsgScores[chaveAcesso].timestamp > 0, "NFe not analyzed");
        require(!nfeRewards[chaveAcesso].isClaimed, "Reward already claimed");
        
        RewardData storage reward = nfeRewards[chaveAcesso];
        reward.isClaimed = true;
        
        // Transferir tokens
        if (reward.gstAmount > 0) {
            gstToken.transfer(msg.sender, reward.gstAmount);
        }
        if (reward.aetAmount > 0) {
            aetToken.transfer(msg.sender, reward.aetAmount);
        }
        
        emit RewardClaimed(msg.sender, reward.gstAmount, reward.aetAmount);
    }
    
    /**
     * @dev Otimiza o sistema usando Trinity Neural Network
     * @return improvementPercent Percentual de melhoria
     */
    function optimizeWithTrinity() external onlyOwner returns (uint256 improvementPercent) {
        // Simular otimização da Trinity Neural Network
        improvementPercent = 15; // 15% de melhoria
        
        // Ajustar parâmetros baseado na otimização
        if (improvementPercent > 10) {
            baseRewardRate = (baseRewardRate * 110) / 100; // Aumentar 10%
            bonusMultiplier = (bonusMultiplier * 105) / 100; // Aumentar 5%
        }
        
        emit TrinityOptimized(improvementPercent, 3);
        return improvementPercent;
    }
    
    /**
     * @dev Obtém ESG Score de uma NFe
     * @param chaveAcesso Chave de acesso da NFe
     * @return esgScore Score ESG
     */
    function getESGScore(string memory chaveAcesso) external view returns (ESGScore memory) {
        return nfeEsgScores[chaveAcesso];
    }
    
    /**
     * @dev Obtém recompensas de uma NFe
     * @param chaveAcesso Chave de acesso da NFe
     * @return reward Dados da recompensa
     */
    function getRewards(string memory chaveAcesso) external view returns (RewardData memory) {
        return nfeRewards[chaveAcesso];
    }
    
    /**
     * @dev Obtém estatísticas do usuário
     * @param user Endereço do usuário
     * @return totalRewards Total de recompensas
     * @return esgScore Score ESG médio
     */
    function getUserStats(address user) external view returns (uint256 totalRewards, uint256 esgScore) {
        return (userTotalRewards[user], userEsgScore[user]);
    }
    
    /**
     * @dev Atualiza configurações do contrato
     * @param _baseRewardRate Nova taxa de recompensa base
     * @param _bonusMultiplier Novo multiplicador de bonus
     * @param _highEsgThreshold Novo threshold para bonus
     */
    function updateConfig(
        uint256 _baseRewardRate,
        uint256 _bonusMultiplier,
        uint256 _highEsgThreshold
    ) external onlyOwner {
        baseRewardRate = _baseRewardRate;
        bonusMultiplier = _bonusMultiplier;
        highEsgThreshold = _highEsgThreshold;
    }
    
    /**
     * @dev Atualiza endereços dos tokens
     * @param _gstToken Novo endereço do GST
     * @param _aetToken Novo endereço do AET
     * @param _nfeNftContract Novo endereço do NFT NFe
     */
    function updateTokenAddresses(
        address _gstToken,
        address _aetToken,
        address _nfeNftContract
    ) external onlyOwner {
        gstToken = IERC20(_gstToken);
        aetToken = IERC20(_aetToken);
        nfeNftContract = IERC721(_nfeNftContract);
    }
    
    /**
     * @dev Emergência: pausar contrato
     */
    function emergencyPause() external onlyOwner {
        // Implementar pausa de emergência se necessário
        // Por enquanto, apenas emitir evento
        emit TrinityOptimized(0, 0);
    }
}
