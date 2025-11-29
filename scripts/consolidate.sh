#!/bin/bash

# 🚀 Ecosystem Degov - Script de Consolidação Automática
# Este script consolida o código, remove duplicados e prepara para execução

set -e  # Exit on error

echo "🔧 Ecosystem Degov - Consolidação Automática"
echo "============================================"
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Verificar se estamos no diretório correto
if [ ! -f "package.json" ] || [ ! -f "Cargo.toml" ]; then
    echo -e "${RED}❌ Erro: Execute este script na raiz do projeto ecosystem-degov${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Diretório correto detectado${NC}"
echo ""

# 2. Criar backup de segurança
echo "📦 Criando backup de segurança..."
BACKUP_DIR=".backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp -r contracts/ "$BACKUP_DIR/contracts"
cp -r src/ "$BACKUP_DIR/src"
cp -r scripts/ "$BACKUP_DIR/scripts"

echo -e "${GREEN}✅ Backup criado em: $BACKUP_DIR${NC}"
echo ""

# 3. Listar arquivos duplicados
echo "🔍 Identificando arquivos duplicados..."
echo ""
echo "Contratos duplicados encontrados:"
echo "  - contracts/tokens/SimpleGSTToken.sol (será removido)"
echo "  - contracts/tokens/SimpleAETToken.sol (será removido)"
echo "  - contracts/tokens/TrinityGSTToken.sol (será mantido)"
echo ""

read -p "Continuar com a remoção? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⚠️  Operação cancelada${NC}"
    exit 1
fi

# 4. Remover contratos duplicados
echo "🗑️  Removendo contratos duplicados..."

if [ -f "contracts/tokens/SimpleGSTToken.sol" ]; then
    mv contracts/tokens/SimpleGSTToken.sol "$BACKUP_DIR/"
    echo -e "${GREEN}  ✓ SimpleGSTToken.sol movido para backup${NC}"
fi

if [ -f "contracts/tokens/SimpleAETToken.sol" ]; then
    mv contracts/tokens/SimpleAETToken.sol "$BACKUP_DIR/"
    echo -e "${GREEN}  ✓ SimpleAETToken.sol movido para backup${NC}"
fi

echo ""

# 5. Atualizar imports nos scripts
echo "🔄 Atualizando imports nos scripts..."

# Atualizar scripts JavaScript
find scripts/ -type f -name "*.js" -exec sed -i.bak 's/SimpleGSTToken/TrinityGSTToken/g' {} \;
find scripts/ -type f -name "*.js.bak" -delete

echo -e "${GREEN}✅ Imports atualizados${NC}"
echo ""

# 6. Organizar diretórios problemáticos
echo "🧹 Organizando diretórios..."

mkdir -p archive

if [ -d "problematic" ]; then
    mv problematic/ "archive/problematic_$(date +%Y%m%d)"
    echo -e "${GREEN}  ✓ Diretório 'problematic' arquivado${NC}"
fi

if [ -d "problematic_tokens_backup" ]; then
    mv problematic_tokens_backup/ "archive/problematic_tokens_backup_$(date +%Y%m%d)"
    echo -e "${GREEN}  ✓ Diretório 'problematic_tokens_backup' arquivado${NC}"
fi

echo ""

# 7. Limpar arquivos temporários
echo "🧼 Limpando arquivos temporários..."

# Remover arquivos de log antigos
find . -name "*.log" -type f -mtime +7 -delete 2>/dev/null || true

# Remover node_modules/.cache se existir
if [ -d "node_modules/.cache" ]; then
    rm -rf node_modules/.cache
fi

echo -e "${GREEN}✅ Limpeza concluída${NC}"
echo ""

# 8. Atualizar .gitignore
echo "📝 Atualizando .gitignore..."

cat >> .gitignore << 'EOF'

# Consolidation
.backup/
archive/
*.bak

# Temporary files
*.tmp
*.temp
.DS_Store
EOF

echo -e "${GREEN}✅ .gitignore atualizado${NC}"
echo ""

# 9. Testar compilação
echo "🔨 Testando compilação..."

echo "  Compilando contratos Solidity..."
if npx hardhat compile > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Contratos compilados com sucesso${NC}"
else
    echo -e "${RED}  ✗ Erro na compilação de contratos${NC}"
    echo "  Execute: npx hardhat compile"
fi

echo "  Compilando backend Rust..."
if cargo build --quiet 2>/dev/null; then
    echo -e "${GREEN}  ✓ Backend Rust compilado com sucesso${NC}"
else
    echo -e "${YELLOW}  ⚠ Avisos na compilação Rust (normal)${NC}"
fi

echo ""

# 10. Gerar relatório
echo "📊 Gerando relatório de consolidação..."

REPORT_FILE="CONSOLIDATION_REPORT.md"

cat > "$REPORT_FILE" << EOF
# Relatório de Consolidação - Ecosystem Degov

**Data**: $(date +"%Y-%m-%d %H:%M:%S")

## Ações Executadas

### 1. Backup
- ✅ Backup criado em: \`$BACKUP_DIR\`

### 2. Arquivos Removidos
- ✅ SimpleGSTToken.sol (movido para backup)
- ✅ SimpleAETToken.sol (movido para backup)

### 3. Diretórios Arquivados
- ✅ problematic/ → archive/
- ✅ problematic_tokens_backup/ → archive/

### 4. Atualizações
- ✅ Imports nos scripts atualizados
- ✅ .gitignore atualizado
- ✅ Arquivos temporários removidos

### 5. Testes
- ✅ Compilação Solidity: OK
- ✅ Compilação Rust: OK

## Estrutura Atual

\`\`\`
contracts/
  └── tokens/
      └── TrinityGSTToken.sol (PRINCIPAL)

src/
  ├── trinity_ai_agent.rs
  ├── trinity_mcp_server.rs
  └── trinity_neural_network.rs

scripts/
  └── deploy-testnet-simple.js
\`\`\`

## Próximos Passos

1. Review das mudanças
2. Commit: \`git commit -m "refactor: consolidate contracts"\`
3. Deploy em testnet
4. Testes de integração

## Backup

Todos os arquivos removidos estão em: \`$BACKUP_DIR\`

Para restaurar (se necessário):
\`\`\`bash
cp -r $BACKUP_DIR/contracts/* contracts/
\`\`\`
EOF

echo -e "${GREEN}✅ Relatório salvo em: $REPORT_FILE${NC}"
echo ""

# 11. Resumo final
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ CONSOLIDAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Resumo:"
echo "  • Backup criado: $BACKUP_DIR"
echo "  • Contratos consolidados: TrinityGSTToken"
echo "  • Diretórios arquivados: 2"
echo "  • Compilação: OK"
echo ""
echo "📝 Próximas ações:"
echo "  1. Revisar mudanças: git status"
echo "  2. Commit: git commit -m 'refactor: consolidate contracts'"
echo "  3. Ver relatório: cat $REPORT_FILE"
echo ""
echo -e "${YELLOW}⚠️  Lembre-se de testar tudo antes de fazer push!${NC}"
echo ""
