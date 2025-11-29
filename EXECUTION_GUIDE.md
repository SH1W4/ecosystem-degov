# 🚀 Guia de Execução Imediata - Ecosystem Degov

## ⚡ START HERE - Próximas 24 Horas

### 1. Backup e Preparação (30 minutos)

```bash
# 1. Criar backup completo
cd c:\Users\João\Desktop\PROJETOS\02_ORGANIZATIONS\ecosystem-degov
git checkout -b backup-$(date +%Y%m%d)
git add -A
git commit -m "backup: snapshot before consolidation"
git push origin backup-$(date +%Y%m%d)

# 2. Criar branch de trabalho
git checkout -b consolidation
```

### 2. Consolidação de Código (2 horas)

```bash
# Script de consolidação automática
# Salvar como: scripts/consolidate.sh

#!/bin/bash

echo "🔧 Iniciando consolidação..."

# 1. Backup de segurança
mkdir -p .backup
cp -r contracts/ .backup/contracts_$(date +%Y%m%d)
cp -r src/ .backup/src_$(date +%Y%m%d)

# 2. Remover duplicados
echo "📦 Removendo contratos duplicados..."
rm -f contracts/tokens/SimpleGSTToken.sol
rm -f contracts/tokens/SimpleAETToken.sol

# 3. Manter apenas TrinityGSTToken
echo "✅ Mantendo apenas TrinityGSTToken..."
# (já está em contracts/tokens/TrinityGSTToken.sol)

# 4. Atualizar imports nos scripts
echo "🔄 Atualizando imports..."
find scripts/ -type f -name "*.js" -exec sed -i 's/SimpleGSTToken/TrinityGSTToken/g' {} +

# 5. Limpar diretórios problemáticos
echo "🧹 Limpando diretórios..."
mkdir -p archive
mv problematic/ archive/problematic_$(date +%Y%m%d)
mv problematic_tokens_backup/ archive/

# 6. Commit
echo "💾 Commitando mudanças..."
git add -A
git commit -m "refactor: consolidate contracts and clean directories"

echo "✅ Consolidação completa!"
```

### 3. Configurar Testnet (1 hora)

```bash
# 1. Obter credenciais
# Acesse: https://infura.io/ ou https://alchemy.com/
# Crie projeto e copie API key

# 2. Obter ETH de teste
# Acesse: https://sepoliafaucet.com/
# Cole seu endereço de wallet

# 3. Configurar .env
cat > .env.testnet << EOF
# Testnet Configuration
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE

# Contract Addresses (will be filled after deploy)
GST_TOKEN_ADDRESS=
TRINITY_AI_ADDRESS=

# API Keys
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_KEY
EOF

echo "⚠️  IMPORTANTE: Preencha as variáveis no arquivo .env.testnet"
```

### 4. Deploy em Testnet (30 minutos)

```bash
# Script de deploy simplificado
# Salvar como: scripts/deploy-testnet-simple.js

const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying to Sepolia testnet...");

  // 1. Deploy TrinityGSTToken
  const TrinityGST = await hre.ethers.getContractFactory("TrinityGSTToken");
  const gst = await TrinityGST.deploy();
  await gst.deployed();
  
  console.log("✅ TrinityGSTToken deployed to:", gst.address);

  // 2. Verificar no Etherscan
  console.log("🔍 Verifying contract...");
  await hre.run("verify:verify", {
    address: gst.address,
    constructorArguments: [],
  });

  console.log("✅ Contract verified!");
  
  // 3. Salvar endereços
  const fs = require('fs');
  const addresses = {
    gstToken: gst.address,
    network: "sepolia",
    deployedAt: new Date().toISOString()
  };
  
  fs.writeFileSync(
    'deployments/sepolia-addresses.json',
    JSON.stringify(addresses, null, 2)
  );

  console.log("💾 Addresses saved to deployments/sepolia-addresses.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

```bash
# Executar deploy
npx hardhat run scripts/deploy-testnet-simple.js --network sepolia
```

---

## 📋 Checklist de Execução

### Fase 1: Preparação (Hoje)
- [ ] Fazer backup completo
- [ ] Criar branch `consolidation`
- [ ] Executar script de consolidação
- [ ] Testar build local
- [ ] Commit e push

### Fase 2: Testnet (Amanhã)
- [ ] Obter credenciais Infura/Alchemy
- [ ] Obter ETH de teste
- [ ] Configurar .env.testnet
- [ ] Deploy TrinityGSTToken
- [ ] Verificar no Etherscan

### Fase 3: Validação (Próximos 3 dias)
- [ ] Testar funções do contrato
- [ ] Configurar Trinity AI Agent
- [ ] Testar integração completa
- [ ] Documentar resultados

---

## 🎯 MVP Simplificado - Foco Absoluto

### O Que Incluir no MVP

**1. Smart Contract** ✅
- TrinityGSTToken (já implementado)
- Funções: mint, transfer, stake, rewards

**2. Backend Mínimo** 🔄
- Trinity AI Agent básico
- API REST simples
- Conexão com blockchain

**3. Frontend Essencial** ⏳
- Wallet connection (MetaMask)
- Balance display
- Stake interface
- Claim rewards

### O Que NÃO Incluir (Por Enquanto)

❌ Outros 7 tokens (AET, ECT, ECS, CCR, ECR, EST, EGM)  
❌ Integração GuardDrive completa  
❌ Integração GuardFlow completa  
❌ Rede neural avançada  
❌ Marketplace de NFTs  
❌ Governança DAO  

**Razão**: Foco em validar 1 token + 1 caso de uso primeiro

---

## 🚀 Scripts de Automação

### Script 1: Setup Completo

```bash
#!/bin/bash
# setup-project.sh

echo "🚀 Setting up Ecosystem Degov..."

# 1. Install dependencies
echo "📦 Installing dependencies..."
npm install
cargo build

# 2. Setup environment
echo "⚙️  Setting up environment..."
cp .env.example .env
echo "⚠️  Please fill in .env with your credentials"

# 3. Compile contracts
echo "🔨 Compiling contracts..."
npx hardhat compile

# 4. Run tests
echo "🧪 Running tests..."
npx hardhat test

echo "✅ Setup complete!"
echo "📝 Next steps:"
echo "  1. Fill in .env file"
echo "  2. Get testnet ETH"
echo "  3. Run: npm run deploy:testnet"
```

### Script 2: Deploy Completo

```bash
#!/bin/bash
# deploy-all.sh

echo "🚀 Deploying Ecosystem Degov..."

# 1. Deploy contracts
echo "📝 Deploying contracts..."
npx hardhat run scripts/deploy-testnet-simple.js --network sepolia

# 2. Start backend
echo "🔧 Starting backend..."
cargo run --bin trinity_ai_agent &

# 3. Start frontend (quando pronto)
# cd frontend && npm run dev &

echo "✅ Deployment complete!"
echo "🌐 Contract address: $(cat deployments/sepolia-addresses.json | jq -r '.gstToken')"
```

### Script 3: Testes Rápidos

```bash
#!/bin/bash
# quick-test.sh

echo "🧪 Running quick tests..."

# 1. Test contracts
npx hardhat test --grep "TrinityGST"

# 2. Test backend
cargo test

# 3. Check deployment
if [ -f "deployments/sepolia-addresses.json" ]; then
  echo "✅ Deployment found"
  cat deployments/sepolia-addresses.json
else
  echo "⚠️  No deployment found"
fi
```

---

## 📊 Métricas de Progresso

### Semana 1: Consolidação
- [ ] Código consolidado: 0% → 100%
- [ ] Testes passando: ? → 100%
- [ ] Documentação atualizada: ? → 90%

### Semana 2: MVP
- [ ] Contrato em testnet: Não → Sim
- [ ] Backend funcionando: Não → Sim
- [ ] Frontend iniciado: 0% → 50%

### Semana 3: Validação
- [ ] Beta testers: 0 → 100
- [ ] Feedback coletado: 0% → 80%
- [ ] Bugs corrigidos: ? → 95%

### Semana 4: Preparação
- [ ] Pitch deck: 0% → 100%
- [ ] Conversas funding: 0 → 3+
- [ ] Parcerias: 0 → 2+

---

## 🎯 Comandos Rápidos

```bash
# Consolidar projeto
bash scripts/consolidate.sh

# Setup completo
bash scripts/setup-project.sh

# Deploy testnet
npx hardhat run scripts/deploy-testnet-simple.js --network sepolia

# Testar tudo
bash scripts/quick-test.sh

# Iniciar desenvolvimento
npm run dev
cargo run
```

---

## 📞 Recursos e Links

### Testnet
- **Sepolia Faucet**: https://sepoliafaucet.com/
- **Sepolia Explorer**: https://sepolia.etherscan.io/
- **Infura**: https://infura.io/
- **Alchemy**: https://alchemy.com/

### Funding
- **a16z crypto**: https://a16zcrypto.com/
- **Binance Labs**: https://labs.binance.com/
- **Ethereum Foundation**: https://ethereum.foundation/
- **Gitcoin Grants**: https://gitcoin.co/grants/

### Comunidade
- **Ethereum Discord**: https://discord.gg/ethereum
- **Polygon Discord**: https://discord.gg/polygon
- **BuildSpace**: https://buildspace.so/

---

## ✅ Próxima Ação AGORA

**Execute este comando**:
```bash
cd c:\Users\João\Desktop\PROJETOS\02_ORGANIZATIONS\ecosystem-degov
git checkout -b consolidation
```

**Depois**:
1. Revisar arquivos duplicados
2. Executar consolidação
3. Testar build
4. Commit mudanças

**Tempo estimado**: 3 horas  
**Resultado**: Projeto limpo e pronto para testnet

---

**🚀 TUDO ENGATILHADO E PRONTO PARA EXECUÇÃO!**
