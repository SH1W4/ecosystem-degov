# 🚀 **GUIA DE DEPLOY - GOERLI TESTNET**

## 📋 **PREPARAÇÃO PARA DEPLOY**

### **1. 🔧 Configuração do Ambiente**

#### **1.1 Instalar Dependências**
```bash
# Instalar dependências Node.js
npm install

# Instalar dependências Rust (se necessário)
cargo build
```

#### **1.2 Configurar Variáveis de Ambiente**
```bash
# Copiar arquivo de exemplo
cp config/goerli.env.example .env

# Editar .env com suas chaves
nano .env
```

#### **1.3 Configurações Necessárias**
```env
# Infura/Alchemy URL
GOERLI_URL=https://goerli.infura.io/v3/YOUR_INFURA_PROJECT_ID

# Sua chave privada (SEM 0x)
PRIVATE_KEY=your_private_key_without_0x

# Etherscan API Key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### **2. 💰 Obter ETH de Teste**

#### **2.1 Faucets Goerli**
- **Alchemy Faucet**: https://goerli-faucet.pk910.de/
- **Infura Faucet**: https://goerli-faucet.mudit.blog/
- **Chainlink Faucet**: https://faucets.chain.link/goerli

#### **2.2 Quantidade Necessária**
- **Mínimo**: 0.01 ETH
- **Recomendado**: 0.1 ETH
- **Para testes completos**: 0.5 ETH

---

## 🚀 **PROCESSO DE DEPLOY**

### **1. 🔍 Verificar Configuração**
```bash
# Verificar se as variáveis estão configuradas
npx hardhat console --network goerli

# No console, testar conexão:
> const [deployer] = await ethers.getSigners()
> console.log("Deployer:", deployer.address)
> console.log("Balance:", ethers.utils.formatEther(await deployer.getBalance()))
```

### **2. 🏗️ Executar Deploy**
```bash
# Deploy completo na Goerli
npx hardhat run scripts/deploy-goerli.js --network goerli
```

### **3. ✅ Verificar Deploy**
```bash
# Verificar contratos no Etherscan
npx hardhat verify --network goerli GST_TOKEN_ADDRESS "Green Sustainability Token" "GST" "1000000000000000000000000000" DEPLOYER_ADDRESS
```

---

## 📊 **RESULTADOS ESPERADOS**

### **✅ Contratos Deployados**
- **GST Token**: Green Sustainability Token (Principal)
- **AET Token**: AI Ethics Token
- **ECT Token**: EcoToken (Environmental)
- **CCR Token**: Carbon Credit Token

### **📄 Arquivo de Deploy**
```json
{
  "network": "goerli",
  "chainId": 5,
  "deployer": "0x...",
  "timestamp": "2025-12-10T...",
  "contracts": {
    "GST": {
      "address": "0x...",
      "name": "Green Sustainability Token",
      "symbol": "GST",
      "totalSupply": "1000000000"
    }
  }
}
```

---

## 🔗 **VERIFICAÇÃO NO ETHERSCAN**

### **1. 📋 Links de Verificação**
- **GST Token**: https://goerli.etherscan.io/address/[ADDRESS]
- **AET Token**: https://goerli.etherscan.io/address/[ADDRESS]
- **ECT Token**: https://goerli.etherscan.io/address/[ADDRESS]
- **CCR Token**: https://goerli.etherscan.io/address/[ADDRESS]

### **2. 🧪 Testes Básicos**
```javascript
// Conectar com contratos deployados
const gstToken = await ethers.getContractAt("SimpleGSTToken", GST_ADDRESS);

// Testar funcionalidades básicas
const name = await gstToken.name();
const symbol = await gstToken.symbol();
const totalSupply = await gstToken.totalSupply();

console.log(`Token: ${name} (${symbol})`);
console.log(`Total Supply: ${ethers.utils.formatEther(totalSupply)}`);
```

---

## 🎯 **PRÓXIMOS PASSOS**

### **1. 🔧 Integração Frontend**
- Conectar com MetaMask
- Implementar interface de usuário
- Testar transações

### **2. 🧪 Testes Avançados**
- Testes de integração
- Testes de carga
- Testes de segurança

### **3. 🌐 Preparação para Mainnet**
- Auditoria de contratos
- Otimização de gas
- Deploy em Ethereum mainnet

---

## ⚠️ **TROUBLESHOOTING**

### **❌ Problemas Comuns**

#### **1. Saldo Insuficiente**
```
Error: insufficient funds for gas
```
**Solução**: Obter mais ETH de teste nos faucets

#### **2. Gas Limit Muito Baixo**
```
Error: gas limit exceeded
```
**Solução**: Aumentar gas limit no hardhat.config.js

#### **3. Rede Incorreta**
```
Error: network mismatch
```
**Solução**: Verificar se está na Goerli (Chain ID: 5)

### **🔧 Comandos de Debug**
```bash
# Verificar rede atual
npx hardhat console --network goerli
> await ethers.provider.getNetwork()

# Verificar saldo
> const [deployer] = await ethers.getSigners()
> await deployer.getBalance()

# Verificar gas price
> await ethers.provider.getGasPrice()
```

---

## 📚 **RECURSOS ADICIONAIS**

### **🔗 Links Úteis**
- **Goerli Faucet**: https://goerli-faucet.pk910.de/
- **Etherscan Goerli**: https://goerli.etherscan.io/
- **Hardhat Docs**: https://hardhat.org/docs
- **OpenZeppelin**: https://docs.openzeppelin.com/

### **📖 Documentação**
- **Smart Contracts**: `contracts/` directory
- **Deploy Scripts**: `scripts/` directory
- **Test Files**: `test/` directory
- **Configuration**: `hardhat.config.js`

---

**🚀 Pronto para deploy na Goerli Testnet!**
