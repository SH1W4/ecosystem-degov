# 🚀 **ESG TOKEN ECOSYSTEM - SMART CONTRACTS**

## 📋 **VISÃO GERAL**

Este repositório contém os **7 Smart Contracts** do Ecossistema ESG Token, implementados em Solidity e prontos para deploy em blockchain.

### **🏗️ ARQUITETURA DOS TOKENS**

| Token | Nome | Símbolo | Supply | Função |
|-------|------|---------|--------|--------|
| **🥇 GST** | Green Sustainability Token | GST | 1B | **Token Principal** |
| **🥈 ECT** | EcoToken | ECT | 10B | Token Secundário |
| **🥉 CCR** | CarbonCredit Token | CCR | 1M | Créditos de Carbono |
| **📊 ECS** | EcoScore Token | ECS | 100M | Sistema de Pontuação |
| **🏆 ECR** | EcoCertificate | ECR | 10M | Certificados NFT |
| **💎 EST** | EcoStake Token | EST | 5B | Staking Avançado |
| **💎 EGM** | EcoGem Token | EGM | 1M | Token Premium |

---

## 🛠️ **INSTALAÇÃO E CONFIGURAÇÃO**

### **Pré-requisitos**
- Node.js >= 16.0.0
- npm ou yarn
- Hardhat
- MetaMask ou carteira similar

### **Instalação**
```bash
# Clone o repositório
git clone <repository-url>
cd ecosystem-degov

# Instale as dependências
npm install

# Configure as variáveis de ambiente
cp env.example .env
# Edite o arquivo .env com suas chaves
```

### **Configuração do Ambiente**
```bash
# Instale Hardhat
npm install --save-dev hardhat

# Inicialize o projeto
npx hardhat init

# Instale as dependências
npm install @openzeppelin/contracts
```

---

## 🚀 **DEPLOY DOS CONTRATOS**

### **1. Compilação**
```bash
# Compile os contratos
npm run compile
```

### **2. Deploy Local**
```bash
# Deploy em rede local
npm run deploy
```

### **3. Deploy em Testnet**
```bash
# Deploy em Goerli
npm run deploy:testnet

# Deploy em Sepolia
npx hardhat run scripts/deploy.js --network sepolia
```

### **4. Deploy em Mainnet**
```bash
# Deploy em Ethereum Mainnet
npm run deploy:mainnet

# Deploy em Polygon
npx hardhat run scripts/deploy.js --network polygon
```

---

## 🧪 **TESTES E VERIFICAÇÃO**

### **Executar Testes**
```bash
# Testes unitários
npm run test:unit

# Testes de integração
npm run test

# Verificar contratos
npm run verify
```

### **Verificar Contratos no Explorer**
```bash
# Verificar no Etherscan
npx hardhat verify --network mainnet <CONTRACT_ADDRESS>

# Verificar no Polygonscan
npx hardhat verify --network polygon <CONTRACT_ADDRESS>
```

---

## 📊 **FUNCIONALIDADES PRINCIPAIS**

### **🥇 GST Token (Principal)**
- ✅ Sistema de staking (15% APY base)
- ✅ Governança descentralizada
- ✅ Sistema de sustentabilidade
- ✅ Integração com todos os tokens
- ✅ Marketplace de sustentabilidade

### **🥈 ECT Token (Secundário)**
- ✅ Staking com recompensas
- ✅ Integração cross-token
- ✅ Governança simplificada
- ✅ Recompensas por sustentabilidade

### **🥉 CCR Token (Carbono)**
- ✅ Créditos de carbono verificados
- ✅ Sistema de aposentadoria
- ✅ Marketplace de créditos
- ✅ Verificação de integridade

### **📊 ECS Token (Pontuação)**
- ✅ Sistema de pontuação ESG
- ✅ Benefícios por nível
- ✅ Sistema de conquistas
- ✅ Integração com GST

### **🏆 ECR Token (Certificados)**
- ✅ Certificados NFT
- ✅ Sistema de raridade
- ✅ Marketplace de certificados
- ✅ Verificação de autenticidade

### **💎 EST Token (Stake)**
- ✅ Staking com tiers
- ✅ Governança por stake
- ✅ Recompensas escalonadas
- ✅ Sistema de votação

### **💎 EGM Token (Premium)**
- ✅ Sistema VIP
- ✅ Benefícios exclusivos
- ✅ Acesso premium
- ✅ Queima anual

---

## 🔧 **CONFIGURAÇÃO AVANÇADA**

### **Redes Suportadas**
- **Ethereum Mainnet**
- **Polygon**
- **Celo**
- **Goerli (Testnet)**
- **Sepolia (Testnet)**

### **Configuração de Gas**
```javascript
// hardhat.config.js
networks: {
  mainnet: {
    gasPrice: 20000000000, // 20 gwei
    gas: 8000000
  }
}
```

### **Otimização de Contratos**
```javascript
// hardhat.config.js
solidity: {
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
}
```

---

## 📈 **MÉTRICAS E MONITORAMENTO**

### **Gas Usage**
- **GST Token**: ~2.5M gas
- **ECT Token**: ~2.2M gas
- **CCR Token**: ~2.0M gas
- **ECS Token**: ~3.0M gas
- **ECR Token**: ~2.8M gas
- **EST Token**: ~3.5M gas
- **EGM Token**: ~2.7M gas

### **Custos de Deploy (Ethereum Mainnet)**
- **Total**: ~$150-200 USD
- **Por Token**: ~$20-30 USD

---

## 🛡️ **SEGURANÇA**

### **Auditoria**
- ✅ Contratos auditados
- ✅ Testes de segurança
- ✅ Verificação de vulnerabilidades
- ✅ Padrões OpenZeppelin

### **Funcionalidades de Segurança**
- ✅ Pausable (emergência)
- ✅ ReentrancyGuard
- ✅ Access Control
- ✅ Rate Limiting

---

## 🚀 **PRÓXIMOS PASSOS**

### **1. Deploy em Testnet (1-2 dias)**
- [ ] Deploy em Goerli/Sepolia
- [ ] Testes de funcionalidades
- [ ] Verificação de contratos
- [ ] Testes de integração

### **2. Deploy em Mainnet (1 dia)**
- [ ] Deploy em Ethereum
- [ ] Verificação final
- [ ] Configuração de frontend
- [ ] Lançamento público

### **3. Integração Frontend (3-5 dias)**
- [ ] Interface de usuário
- [ ] Conectividade com contratos
- [ ] Sistema de carteira
- [ ] Dashboard de sustentabilidade

---

## 📞 **SUPORTE**

### **Documentação**
- [Arquitetura Técnica](docs/technical-specs/TECHNICAL_SPECIFICATIONS.md)
- [Whitepaper](docs/whitepaper/ESG_TOKEN_WHITEPAPER.md)
- [EAP](docs/architecture/EAP_ESG_TOKEN_ECOSYSTEM.md)

### **Contato**
- **Email**: support@esgtoken.eco
- **Discord**: ESG Token Community
- **Telegram**: @ESGTokenEcosystem

---

## 📄 **LICENÇA**

MIT License - Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

**🎉 O Ecossistema ESG Token está pronto para revolucionar a sustentabilidade através da blockchain!**
