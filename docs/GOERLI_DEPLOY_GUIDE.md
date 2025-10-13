# 🚀 Deploy em Goerli Testnet - Guia Completo
## **💰 100% GRATUITO - ETH de Teste**

---

## 📋 **PASSO A PASSO:**

### **1. 🔑 Obter ETH de Teste (GRATUITO):**

#### **Faucets Disponíveis:**
- 🔗 **https://goerlifaucet.com/** (Recomendado)
- 🔗 **https://faucet.quicknode.com/ethereum/goerli**
- 🔗 **https://faucets.chain.link/goerli**
- 🔗 **https://stakely.io/en/faucet/ethereum-goerli**

#### **Como Obter:**
1. Conecte sua wallet (MetaMask, etc.)
2. Copie seu endereço
3. Cole no faucet
4. Clique em "Request ETH"
5. Aguarde alguns minutos

### **2. ⚙️ Configurar Variáveis de Ambiente:**

#### **Criar arquivo `.env` na raiz do projeto:**
```bash
# Goerli Testnet Configuration
GOERLI_URL=https://goerli.infura.io/v3/SEU_INFURA_PROJECT_ID
PRIVATE_KEY=sua_chave_privada_sem_0x_prefix
ETHERSCAN_API_KEY=sua_chave_etherscan_opcional
```

#### **Como Obter Infura ID (GRATUITO):**
1. Acesse: https://infura.io/
2. Crie conta gratuita
3. Crie novo projeto
4. Copie o Project ID
5. Cole no GOERLI_URL

#### **Como Obter Private Key:**
1. Abra MetaMask
2. Clique nos 3 pontos
3. Account Details
4. Export Private Key
5. Copie (sem 0x)

### **3. 🚀 Executar Deploy:**

```bash
# Verificar configuração
npx hardhat console --network goerli

# Executar deploy
npx hardhat run scripts/deploy-goerli-trinity.js --network goerli
```

---

## 💰 **CUSTOS:**

| **Item** | **Custo** | **Observação** |
|----------|-----------|----------------|
| **ETH de Teste** | **GRATUITO** | Faucets disponíveis |
| **Gas** | **GRATUITO** | ETH de teste |
| **Deploy** | **GRATUITO** | Sem custo real |
| **Total** | **R$ 0,00** | 100% gratuito |

---

## ✅ **VANTAGENS:**

- **Ambiente Real**: Mesma tecnologia do Ethereum
- **Testes Completos**: Todas as funcionalidades
- **Sem Riscos**: Nenhum dinheiro real
- **100% Gratuito**: ETH de teste
- **Verificação**: Etherscan público

---

## 🔍 **VERIFICAÇÃO:**

Após o deploy, você pode verificar no Etherscan:
- **Goerli Etherscan**: https://goerli.etherscan.io/
- **Contratos deployados** aparecerão publicamente
- **Transações** são visíveis para todos

---

## 🎯 **RESULTADO ESPERADO:**

```
🎉 DEPLOY GOERLI CONCLUÍDO!
👤 Deployer: 0x...
🏗️ Trinity ESG Contract: 0x...
🔗 GST Token: 0x...
🔗 AET Token: 0x...
💰 Custo total: GRATUITO (ETH de teste)
```

---

## 🆘 **TROUBLESHOOTING:**

### **Erro: "Empty string for network URL"**
- **Solução**: Configurar GOERLI_URL no .env

### **Erro: "No accounts"**
- **Solução**: Configurar PRIVATE_KEY no .env

### **Erro: "Insufficient funds"**
- **Solução**: Obter mais ETH de teste nos faucets

---

## 🧠 **TRINITY AI: SISTEMA ESG + BLOCKCHAIN EM GOERLI!**

**100% GRATUITO + AMBIENTE REAL + SEM RISCOS!** ⚡🚀