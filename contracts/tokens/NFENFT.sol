// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title NFENFT - Nota Fiscal Eletrônica como NFT
 * @dev NFT que representa NFE brasileira com funcionalidades ESG
 * @author Trinity AI Agent
 * @notice Integração GuardDrive/GuardFlow com ecossistema ESG
 */
contract NFENFT is 
    ERC721, 
    ERC721URIStorage, 
    ERC721Enumerable, 
    Ownable, 
    Pausable, 
    ReentrancyGuard 
{
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdCounter;
    
    // Estrutura da NFE
    struct NFEData {
        string chaveAcesso;           // Chave de acesso da NFE
        string numeroNFE;             // Número da NFE
        string serie;                 // Série da NFE
        string cnpjEmitente;          // CNPJ do emitente
        string cnpjDestinatario;      // CNPJ do destinatário
        uint256 valorTotal;           // Valor total da NFE
        uint256 dataEmissao;          // Timestamp da emissão
        string municipioEmissao;      // Município de emissão
        string ufEmissao;            // UF de emissão
        uint256 esgScore;            // Pontuação ESG (0-100)
        bool isVerificada;           // NFE verificada
        string categoria;            // Categoria do produto/serviço
    }
    
    // Mapeamentos
    mapping(uint256 => NFEData) public nfeData;
    mapping(string => bool) public chaveAcessoUsada;
    mapping(address => uint256[]) public nfePorProprietario;
    mapping(string => uint256) public nfePorChave;
    
    // Eventos
    event NFEConvertida(
        uint256 indexed tokenId,
        string chaveAcesso,
        address indexed proprietario,
        uint256 esgScore
    );
    
    event ESGScoreAtualizado(
        uint256 indexed tokenId,
        uint256 novoScore,
        uint256 timestamp
    );
    
    event NFEVerificada(
        uint256 indexed tokenId,
        bool verificada,
        uint256 timestamp
    );
    
    // Construtor
    constructor() ERC721("NFE NFT", "NFENFT") {
        // Iniciar tokenId em 1
        _tokenIdCounter.increment();
    }
    
    /**
     * @dev Converte NFE em NFT
     * @param _chaveAcesso Chave de acesso da NFE
     * @param _numeroNFE Número da NFE
     * @param _serie Série da NFE
     * @param _cnpjEmitente CNPJ do emitente
     * @param _cnpjDestinatario CNPJ do destinatário
     * @param _valorTotal Valor total da NFE
     * @param _municipioEmissao Município de emissão
     * @param _ufEmissao UF de emissão
     * @param _categoria Categoria do produto/serviço
     * @param _tokenURI URI do token (metadados)
     */
    function converterNFE(
        string memory _chaveAcesso,
        string memory _numeroNFE,
        string memory _serie,
        string memory _cnpjEmitente,
        string memory _cnpjDestinatario,
        uint256 _valorTotal,
        string memory _municipioEmissao,
        string memory _ufEmissao,
        string memory _categoria,
        string memory _tokenURI
    ) external whenNotPaused nonReentrant returns (uint256) {
        require(!chaveAcessoUsada[_chaveAcesso], "NFE ja convertida");
        require(_valorTotal > 0, "Valor deve ser maior que zero");
        require(bytes(_chaveAcesso).length > 0, "Chave de acesso invalida");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        // Criar NFT
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        
        // Calcular ESG Score inicial
        uint256 esgScore = _calcularESGScore(_categoria, _valorTotal, _municipioEmissao);
        
        // Armazenar dados da NFE
        nfeData[tokenId] = NFEData({
            chaveAcesso: _chaveAcesso,
            numeroNFE: _numeroNFE,
            serie: _serie,
            cnpjEmitente: _cnpjEmitente,
            cnpjDestinatario: _cnpjDestinatario,
            valorTotal: _valorTotal,
            dataEmissao: block.timestamp,
            municipioEmissao: _municipioEmissao,
            ufEmissao: _ufEmissao,
            esgScore: esgScore,
            isVerificada: false,
            categoria: _categoria
        });
        
        // Atualizar mapeamentos
        chaveAcessoUsada[_chaveAcesso] = true;
        nfePorProprietario[msg.sender].push(tokenId);
        nfePorChave[_chaveAcesso] = tokenId;
        
        emit NFEConvertida(tokenId, _chaveAcesso, msg.sender, esgScore);
        
        return tokenId;
    }
    
    /**
     * @dev Atualiza ESG Score de uma NFE
     * @param _tokenId ID do token NFT
     * @param _novoScore Novo score ESG
     */
    function atualizarESGScore(uint256 _tokenId, uint256 _novoScore) 
        external 
        onlyOwner 
        whenNotPaused 
    {
        require(_exists(_tokenId), "Token nao existe");
        require(_novoScore <= 100, "Score deve ser <= 100");
        
        nfeData[_tokenId].esgScore = _novoScore;
        
        emit ESGScoreAtualizado(_tokenId, _novoScore, block.timestamp);
    }
    
    /**
     * @dev Verifica NFE
     * @param _tokenId ID do token NFT
     * @param _verificada Status de verificação
     */
    function verificarNFE(uint256 _tokenId, bool _verificada) 
        external 
        onlyOwner 
        whenNotPaused 
    {
        require(_exists(_tokenId), "Token nao existe");
        
        nfeData[_tokenId].isVerificada = _verificada;
        
        emit NFEVerificada(_tokenId, _verificada, block.timestamp);
    }
    
    /**
     * @dev Calcula ESG Score baseado em critérios
     * @param _categoria Categoria do produto/serviço
     * @param _valorTotal Valor total da NFE
     * @param _municipio Município de emissão
     * @return Score ESG (0-100)
     */
    function _calcularESGScore(
        string memory _categoria, 
        uint256 _valorTotal, 
        string memory _municipio
    ) internal pure returns (uint256) {
        uint256 score = 50; // Score base
        
        // Critérios ambientais
        if (keccak256(bytes(_categoria)) == keccak256(bytes("Energia Renovavel"))) {
            score += 30;
        } else if (keccak256(bytes(_categoria)) == keccak256(bytes("Reciclagem"))) {
            score += 25;
        } else if (keccak256(bytes(_categoria)) == keccak256(bytes("Sustentavel"))) {
            score += 20;
        }
        
        // Critérios sociais
        if (keccak256(bytes(_municipio)) == keccak256(bytes("Sao Paulo"))) {
            score += 10; // Incentivo para SP
        }
        
        // Critérios de governança
        if (_valorTotal >= 10000) { // NFE de alto valor
            score += 15;
        }
        
        return score > 100 ? 100 : score;
    }
    
    /**
     * @dev Retorna NFE por chave de acesso
     * @param _chaveAcesso Chave de acesso da NFE
     * @return tokenId ID do token
     */
    function getNFEPorChave(string memory _chaveAcesso) 
        external 
        view 
        returns (uint256) 
    {
        return nfePorChave[_chaveAcesso];
    }
    
    /**
     * @dev Retorna NFTs de um proprietário
     * @param _proprietario Endereço do proprietário
     * @return Array de token IDs
     */
    function getNFEsPorProprietario(address _proprietario) 
        external 
        view 
        returns (uint256[] memory) 
    {
        return nfePorProprietario[_proprietario];
    }
    
    /**
     * @dev Retorna dados completos de uma NFE
     * @param _tokenId ID do token
     * @return Dados completos da NFE
     */
    function getNFEData(uint256 _tokenId) 
        external 
        view 
        returns (NFEData memory) 
    {
        require(_exists(_tokenId), "Token nao existe");
        return nfeData[_tokenId];
    }
    
    /**
     * @dev Pausa o contrato
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Despausa o contrato
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    // Overrides necessários
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
    
    function _burn(uint256 tokenId) 
        internal 
        override(ERC721, ERC721URIStorage) 
    {
        super._burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
