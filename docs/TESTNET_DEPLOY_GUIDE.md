# 🚀 Guia de Deploy em Testnet - Passo a Passo

## 📋 Pré-requisitos

Antes de começar, você precisa:
- [ ] Node.js 18+ instalado
- [ ] Conta Infura ou Alchemy
- [ ] Carteira MetaMask configurada
- [ ] ETH de teste (Sepolia)

---

## 🔧 Passo 1: Configurar Provedor RPC

### Opção A: Infura (Recomendado)

1. Acesse: https://infura.io/
2. Crie uma conta gratuita
3. Crie um novo projeto
4. Copie a **API Key** e o **Endpoint Sepolia**

### Opção B: Alchemy

1. Acesse: https://alchemy.com/
2. Crie uma conta gratuita
3. Crie um novo app (Sepolia testnet)
4. Copie a **API Key**

---

## 💰 Passo 2: Obter ETH de Teste

### Sepolia Faucets (Gratuitos)

1. **Alchemy Faucet**: https://sepoliafaucet.com/
   - Login com conta Alchemy
   - Cole seu endereço de carteira
   - Receba 0.5 ETH de teste

2. **Infura Faucet**: https://www.infura.io/faucet/sepolia
   - Login com conta Infura
   - Cole seu endereço de carteira
   - Receba 0.5 ETH de teste

3. **QuickNode Faucet**: https://faucet.quicknode.com/ethereum/sepolia
   - Cole seu endereço
   - Receba 0.1 ETH de teste

**Dica**: Use múltiplos faucets para obter mais ETH de teste se necessário.

---

## 🔐 Passo 3: Configurar Variáveis de Ambiente

### 3.1 Criar arquivo .env

Crie um arquivo `.env` na raiz do projeto:

```bash
# Copiar template
cp .env.example .env
```

### 3.2 Preencher .env

Abra `.env` e preencha:

```env
# Network RPC URLs
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/SUA_API_KEY_AQUI

# Private Key (NUNCA compartilhe!)
# Obtenha do MetaMask: Settings > Security & Privacy > Show Private Key
PRIVATE_KEY=sua_private_key_aqui_sem_0x

# Etherscan API Key (para verificação de contrato)
# Obtenha em: https://etherscan.io/myapikey
ETHERSCAN_API_KEY=sua_etherscan_key_aqui

# Contract Addresses (serão preenchidos após deploy)
GST_TOKEN_ADDRESS=
TRINITY_AI_ADDRESS=
```

**⚠️ IMPORTANTE**: 
- Nunca commite o arquivo `.env` no git
- Use uma carteira de teste, não sua carteira principal
- Mantenha a private key segura

---

## 🚀 Passo 4: Deploy do Contrato

### 4.1 Testar Compilação

```bash
npx hardhat compile
```

**Resultado esperado**: "Compiled X Solidity files successfully"

### 4.2 Executar Deploy

```bash
npx hardhat run scripts/deploy-testnet-simple.js --network sepolia
```

**O que acontece**:
1. Conecta com Sepolia via Infura/Alchemy
2. Verifica seu balance de ETH
3. Deploy do TrinityGSTToken
4. Aguarda confirmação
5. Salva endereços em `deployments/sepolia-deployment.json`

**Tempo estimado**: 2-5 minutos

### 4.3 Resultado Esperado

```
🚀 Ecosystem Degov - Deploy em Testnet
=====================================

📡 Rede: sepolia (chainId: 11155111)
👤 Deployer: 0x1234...5678
💰 Balance: 0.5 ETH

📝 Deploying TrinityGSTToken...
⏳ Aguardando confirmação...
✅ TrinityGSTToken deployed!
📍 Address: 0xABCD...EF01

🔗 Transaction hash: 0x9876...5432
⛽ Gas used: 1,766,702
💸 Gas price: 2.5 gwei

💾 Deployment info saved to: deployments/sepolia-deployment.json

🔍 Verificando contrato no Etherscan...
⏳ Aguardando 30 segundos para o Etherscan indexar...

✅ Contrato verificado no Etherscan!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ DEPLOY CONCLUÍDO COM SUCESSO!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Informações importantes:
   • Contrato: 0xABCD...EF01
   • Rede: sepolia
   • Explorer: https://sepolia.etherscan.io/address/0xABCD...EF01
```

---

## ✅ Passo 5: Verificar Deploy

### 5.1 No Etherscan

1. Acesse: https://sepolia.etherscan.io/
2. Cole o endereço do contrato
3. Verifique:
   - ✅ Contrato criado
   - ✅ Código verificado (✓)
   - ✅ Funções visíveis na aba "Contract"

### 5.2 Testar Funções Básicas

No Etherscan, aba "Contract" > "Read Contract":

```
1. name() → "Trinity GST Token"
2. symbol() → "GST"
3. totalSupply() → "1000000000000000000000000" (1M tokens)
4. MAX_SUPPLY() → "21000000000000000000000000" (21M tokens)
```

### 5.3 Testar Transação

No Etherscan, aba "Contract" > "Write Contract":

1. Conecte sua carteira (Connect to Web3)
2. Teste função `transfer`:
   - to: `0x0000000000000000000000000000000000000001`
   - amount: `1000000000000000000` (1 token)
3. Confirme transação
4. Verifique na aba "Transactions"

---

## 📊 Passo 6: Documentar Deploy

### 6.1 Atualizar README

Adicione no README.md:

```markdown
## 🌐 Deployed Contracts

### Sepolia Testnet
- **TrinityGSTToken**: [0xABCD...EF01](https://sepolia.etherscan.io/address/0xABCD...EF01)
- **Deployed**: 2025-11-29
- **Status**: ✅ Verified
```

### 6.2 Criar Badge

Adicione badge no README:

```markdown
![Sepolia](https://img.shields.io/badge/Sepolia-Deployed-success?style=for-the-badge&logo=ethereum)
```

---

## 🐛 Troubleshooting

### Erro: "Insufficient funds"
**Solução**: Obtenha mais ETH de teste nos faucets

### Erro: "Invalid API key"
**Solução**: Verifique se copiou a API key corretamente no `.env`

### Erro: "Network not found"
**Solução**: Verifique se o `hardhat.config.js` está configurado para Sepolia

### Erro: "Nonce too high"
**Solução**: 
```bash
# Reset account nonce
npx hardhat clean
```

### Deploy muito lento
**Solução**: Aumente o gas price no `hardhat.config.js`:
```javascript
gasPrice: 3000000000, // 3 gwei
```

---

## 📝 Checklist de Deploy

- [ ] Conta Infura/Alchemy criada
- [ ] API Key obtida
- [ ] ETH de teste recebido (>0.1 ETH)
- [ ] Arquivo `.env` configurado
- [ ] Private key adicionada (carteira de teste!)
- [ ] Compilação testada (`npx hardhat compile`)
- [ ] Deploy executado
- [ ] Contrato verificado no Etherscan
- [ ] Funções testadas
- [ ] Endereço documentado no README
- [ ] Deployment info salvo

---

## 🎯 Próximos Passos

Após deploy bem-sucedido:

1. **Testar Integração** (Semana 2)
   - Conectar frontend
   - Testar wallet connection
   - Testar transações

2. **MVP** (Semanas 3-4)
   - Implementar 1 integração (GuardDrive ou GuardFlow)
   - Recrutar beta testers
   - Coletar feedback

3. **Pitch Deck** (Semana 1-2)
   - Usar deploy como prova de conceito
   - Mostrar contrato verificado
   - Demonstrar funcionalidade

---

## 📞 Recursos

- **Sepolia Faucet**: https://sepoliafaucet.com/
- **Infura**: https://infura.io/
- **Alchemy**: https://alchemy.com/
- **Etherscan Sepolia**: https://sepolia.etherscan.io/
- **Hardhat Docs**: https://hardhat.org/

---

**Status**: ✅ Guia completo  
**Tempo estimado**: 30-60 minutos  
**Custo**: R$ 0 (testnet gratuita)  
**Dificuldade**: ⭐⭐ (Intermediário)
