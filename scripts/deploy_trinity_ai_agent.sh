#!/bin/bash

# Trinity AI Agent + MCP Server Deploy Script
# Script para deploy do Trinity AI Agent com integração MCP

set -e

echo "🤖 Deploying Trinity AI Agent + MCP Server..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

# Verificar se estamos no diretório correto
if [ ! -f "Cargo.toml" ]; then
    error "Este script deve ser executado no diretório raiz do projeto"
    exit 1
fi

# Verificar dependências
log "Verificando dependências..."

# Verificar Rust
if ! command -v cargo &> /dev/null; then
    error "Rust/Cargo não encontrado. Instale Rust primeiro: https://rustup.rs/"
    exit 1
fi

# Verificar Node.js (para MCP)
if ! command -v node &> /dev/null; then
    warn "Node.js não encontrado. Instalando Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Verificar Python (para MCP)
if ! command -v python3 &> /dev/null; then
    warn "Python3 não encontrado. Instalando Python3..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
fi

# Verificar Docker (opcional)
if ! command -v docker &> /dev/null; then
    warn "Docker não encontrado. Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

# Configurar variáveis de ambiente
log "Configurando variáveis de ambiente..."

# Criar arquivo .env se não existir
if [ ! -f ".env" ]; then
    log "Criando arquivo .env..."
    cat > .env << EOF
# Trinity AI Agent Configuration
TRINITY_API_KEY=trinity-ai-$(openssl rand -hex 16)
TRINITY_ENCRYPTION_KEY=$(openssl rand -hex 32)

# MCP Server Configuration
MCP_PORT=8080
MCP_HOST=0.0.0.0

# LLM API Keys (configure com suas chaves)
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
CLAUDE_API_KEY=your_claude_api_key_here

# Blockchain API Keys
INFURA_API_KEY=your_infura_api_key_here

# Database Configuration
DATABASE_URL=postgresql://localhost:5432/ecosystem_degov
MONGODB_URL=mongodb://localhost:27017/ecosystem_degov

# Logging
RUST_LOG=info
TRINITY_LOG_LEVEL=info
EOF
    warn "Arquivo .env criado. Configure suas chaves de API!"
fi

# Compilar o projeto
log "Compilando Trinity AI Agent..."
cargo build --release

if [ $? -ne 0 ]; then
    error "Falha na compilação"
    exit 1
fi

# Instalar dependências Python para MCP
log "Instalando dependências Python para MCP..."
pip3 install -r requirements.txt 2>/dev/null || {
    log "Criando requirements.txt..."
    cat > requirements.txt << EOF
# Trinity AI Agent Python Dependencies
fastapi==0.104.1
uvicorn==0.24.0
websockets==12.0
aiofiles==23.2.1
python-multipart==0.0.6
pydantic==2.5.0
httpx==0.25.2
asyncio-mqtt==0.16.1
redis==5.0.1
psycopg2-binary==2.9.9
pymongo==4.6.0
cryptography==41.0.8
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-dotenv==1.0.0
EOF
    pip3 install -r requirements.txt
}

# Instalar dependências Node.js para MCP
log "Instalando dependências Node.js para MCP..."
if [ ! -f "package.json" ]; then
    log "Criando package.json..."
    cat > package.json << EOF
{
  "name": "trinity-ai-agent-mcp",
  "version": "1.0.0",
  "description": "Trinity AI Agent MCP Server",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "ws": "^8.14.2",
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "dotenv": "^16.3.1",
    "axios": "^1.6.2",
    "redis": "^4.6.10",
    "pg": "^8.11.3",
    "mongodb": "^6.3.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.2"
  }
}
EOF
fi

npm install

# Criar script de inicialização
log "Criando script de inicialização..."
cat > start_trinity_ai_agent.sh << 'EOF'
#!/bin/bash

# Trinity AI Agent + MCP Server Startup Script

echo "🤖 Starting Trinity AI Agent + MCP Server..."

# Carregar variáveis de ambiente
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Verificar se o processo já está rodando
if pgrep -f "trinity_ai_agent" > /dev/null; then
    echo "⚠️ Trinity AI Agent já está rodando"
    exit 1
fi

# Iniciar Trinity AI Agent
echo "🚀 Starting Trinity AI Agent..."
nohup ./target/release/trinity_ai_agent > logs/trinity_ai_agent.log 2>&1 &
TRINITY_PID=$!

# Aguardar um pouco para o agente inicializar
sleep 5

# Iniciar MCP Server
echo "📡 Starting MCP Server..."
nohup python3 -m uvicorn mcp_server:app --host 0.0.0.0 --port 8080 > logs/mcp_server.log 2>&1 &
MCP_PID=$!

# Salvar PIDs
echo $TRINITY_PID > trinity_ai_agent.pid
echo $MCP_PID > mcp_server.pid

echo "✅ Trinity AI Agent + MCP Server iniciados!"
echo "📊 Trinity AI Agent PID: $TRINITY_PID"
echo "📡 MCP Server PID: $MCP_PID"
echo "🔗 MCP Server: http://localhost:8080"
echo "📋 Logs: logs/trinity_ai_agent.log e logs/mcp_server.log"
EOF

chmod +x start_trinity_ai_agent.sh

# Criar script de parada
log "Criando script de parada..."
cat > stop_trinity_ai_agent.sh << 'EOF'
#!/bin/bash

echo "🛑 Stopping Trinity AI Agent + MCP Server..."

# Parar Trinity AI Agent
if [ -f "trinity_ai_agent.pid" ]; then
    TRINITY_PID=$(cat trinity_ai_agent.pid)
    if kill -0 $TRINITY_PID 2>/dev/null; then
        kill $TRINITY_PID
        echo "✅ Trinity AI Agent parado (PID: $TRINITY_PID)"
    else
        echo "⚠️ Trinity AI Agent já estava parado"
    fi
    rm trinity_ai_agent.pid
fi

# Parar MCP Server
if [ -f "mcp_server.pid" ]; then
    MCP_PID=$(cat mcp_server.pid)
    if kill -0 $MCP_PID 2>/dev/null; then
        kill $MCP_PID
        echo "✅ MCP Server parado (PID: $MCP_PID)"
    else
        echo "⚠️ MCP Server já estava parado"
    fi
    rm mcp_server.pid
fi

echo "✅ Todos os serviços parados!"
EOF

chmod +x stop_trinity_ai_agent.sh

# Criar diretórios necessários
log "Criando diretórios necessários..."
mkdir -p logs
mkdir -p backups
mkdir -p config
mkdir -p scripts

# Criar arquivo de configuração do sistema
log "Criando arquivo de configuração do sistema..."
cat > config/systemd/trinity-ai-agent.service << EOF
[Unit]
Description=Trinity AI Agent + MCP Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/start_trinity_ai_agent.sh
Restart=always
RestartSec=10
Environment=RUST_LOG=info
Environment=TRINITY_LOG_LEVEL=info

[Install]
WantedBy=multi-user.target
EOF

# Criar script de monitoramento
log "Criando script de monitoramento..."
cat > scripts/monitor_trinity_ai_agent.sh << 'EOF'
#!/bin/bash

# Trinity AI Agent + MCP Server Monitoring Script

echo "📊 Trinity AI Agent + MCP Server Status"

# Verificar Trinity AI Agent
if [ -f "trinity_ai_agent.pid" ]; then
    TRINITY_PID=$(cat trinity_ai_agent.pid)
    if kill -0 $TRINITY_PID 2>/dev/null; then
        echo "✅ Trinity AI Agent: RUNNING (PID: $TRINITY_PID)"
    else
        echo "❌ Trinity AI Agent: STOPPED"
    fi
else
    echo "❌ Trinity AI Agent: NOT STARTED"
fi

# Verificar MCP Server
if [ -f "mcp_server.pid" ]; then
    MCP_PID=$(cat mcp_server.pid)
    if kill -0 $MCP_PID 2>/dev/null; then
        echo "✅ MCP Server: RUNNING (PID: $MCP_PID)"
    else
        echo "❌ MCP Server: STOPPED"
    fi
else
    echo "❌ MCP Server: NOT STARTED"
fi

# Verificar logs
echo ""
echo "📋 Recent logs:"
if [ -f "logs/trinity_ai_agent.log" ]; then
    echo "Trinity AI Agent (last 5 lines):"
    tail -5 logs/trinity_ai_agent.log
fi

if [ -f "logs/mcp_server.log" ]; then
    echo "MCP Server (last 5 lines):"
    tail -5 logs/mcp_server.log
fi

# Verificar conectividade
echo ""
echo "🔗 Connectivity check:"
if curl -s http://localhost:8080/health > /dev/null; then
    echo "✅ MCP Server: HEALTHY"
else
    echo "❌ MCP Server: UNHEALTHY"
fi
EOF

chmod +x scripts/monitor_trinity_ai_agent.sh

# Criar script de backup
log "Criando script de backup..."
cat > scripts/backup_trinity_ai_agent.sh << 'EOF'
#!/bin/bash

# Trinity AI Agent + MCP Server Backup Script

BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "💾 Creating backup in $BACKUP_DIR..."

# Backup logs
if [ -d "logs" ]; then
    cp -r logs "$BACKUP_DIR/"
    echo "✅ Logs backed up"
fi

# Backup config
if [ -d "config" ]; then
    cp -r config "$BACKUP_DIR/"
    echo "✅ Config backed up"
fi

# Backup ecosystem state (se existir)
if [ -f "ecosystem_state.json" ]; then
    cp ecosystem_state.json "$BACKUP_DIR/"
    echo "✅ Ecosystem state backed up"
fi

# Backup learning data (se existir)
if [ -f "learning_data.json" ]; then
    cp learning_data.json "$BACKUP_DIR/"
    echo "✅ Learning data backed up"
fi

# Backup performance metrics (se existir)
if [ -f "performance_metrics.json" ]; then
    cp performance_metrics.json "$BACKUP_DIR/"
    echo "✅ Performance metrics backed up"
fi

echo "✅ Backup completed: $BACKUP_DIR"
EOF

chmod +x scripts/backup_trinity_ai_agent.sh

# Criar README para o Trinity AI Agent
log "Criando documentação..."
cat > docs/TRINITY_AI_AGENT_README.md << 'EOF'
# 🤖 Trinity AI Agent + MCP Server

## Visão Geral

O Trinity AI Agent é um agente autônomo para manutenção do ecossistema ESG + IA Ética, integrado com MCP (Model Context Protocol) para comunicação com LLMs e IDEs.

## Características

- **Monitoramento 24/7**: Monitora todos os 8 tokens do ecossistema
- **Otimização Automática**: Otimiza sistemas baseado em dados reais
- **Aprendizado Contínuo**: Aprende e evolui com o tempo
- **Integração MCP**: Comunica com LLMs e IDEs via MCP
- **Self-Healing**: Corrige problemas automaticamente
- **Cross-Chain Sync**: Sincroniza entre múltiplas blockchains

## Instalação

```bash
# Executar script de deploy
./scripts/deploy_trinity_ai_agent.sh
```

## Uso

### Iniciar Serviços
```bash
./start_trinity_ai_agent.sh
```

### Parar Serviços
```bash
./stop_trinity_ai_agent.sh
```

### Monitorar Status
```bash
./scripts/monitor_trinity_ai_agent.sh
```

### Backup
```bash
./scripts/backup_trinity_ai_agent.sh
```

## Configuração

### Variáveis de Ambiente
- `TRINITY_API_KEY`: Chave de API do Trinity AI Agent
- `MCP_PORT`: Porta do MCP Server (padrão: 8080)
- `OPENAI_API_KEY`: Chave da API OpenAI
- `ANTHROPIC_API_KEY`: Chave da API Anthropic
- `INFURA_API_KEY`: Chave da API Infura

### Arquivo de Configuração
Edite `config/trinity_mcp_config.yaml` para configurar:
- Conexões MCP
- Tokens do ecossistema
- Blockchains
- Integrações
- Monitoramento
- Otimização
- Segurança

## Endpoints MCP

### Health Check
```bash
curl http://localhost:8080/health
```

### Ecosystem Status
```bash
curl http://localhost:8080/api/v1/ecosystem/status
```

### Token Analysis
```bash
curl http://localhost:8080/api/v1/tokens/analysis
```

### Blockchain Sync
```bash
curl http://localhost:8080/api/v1/blockchain/sync
```

### Optimization Suggestions
```bash
curl http://localhost:8080/api/v1/optimization/suggestions
```

### AI Ethics Scoring
```bash
curl http://localhost:8080/api/v1/ai-ethics/scoring
```

### ESG Impact Analysis
```bash
curl http://localhost:8080/api/v1/esg/impact-analysis
```

## Logs

- Trinity AI Agent: `logs/trinity_ai_agent.log`
- MCP Server: `logs/mcp_server.log`

## Troubleshooting

### Verificar Status
```bash
./scripts/monitor_trinity_ai_agent.sh
```

### Verificar Logs
```bash
tail -f logs/trinity_ai_agent.log
tail -f logs/mcp_server.log
```

### Reiniciar Serviços
```bash
./stop_trinity_ai_agent.sh
./start_trinity_ai_agent.sh
```

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    TRINITY AI AGENT                        │
├─────────────────────────────────────────────────────────────┤
│  🤖 AGENTE AUTÔNOMO PARA MANUTENÇÃO DO ECOSSISTEMA        │
│  ├── Monitoramento contínuo dos 8 tokens                  │
│  ├── Otimização automática de scoring ESG + IA            │
│  ├── Detecção e correção de problemas                     │
│  ├── Integração cross-chain automática                    │
│  └── Evolução contínua do ecossistema                     │
├─────────────────────────────────────────────────────────────┤
│  📡 MCP SERVER (Model Context Protocol)                   │
│  ├── Integração com LLMs (OpenAI, Anthropic, Claude)      │
│  ├── Integração com IDEs (VSCode, Cursor, IntelliJ)       │
│  ├── Integração com Blockchains (Ethereum, Polygon, etc) │
│  └── Integração com Databases (PostgreSQL, MongoDB)      │
└─────────────────────────────────────────────────────────────┘
```

## Suporte

Para suporte, consulte:
- Logs do sistema
- Documentação técnica
- Issues no repositório
EOF

# Finalizar deploy
log "✅ Deploy do Trinity AI Agent + MCP Server concluído!"
echo ""
echo "🎯 Próximos passos:"
echo "1. Configure suas chaves de API no arquivo .env"
echo "2. Execute: ./start_trinity_ai_agent.sh"
echo "3. Monitore: ./scripts/monitor_trinity_ai_agent.sh"
echo "4. Acesse: http://localhost:8080/health"
echo ""
echo "📚 Documentação: docs/TRINITY_AI_AGENT_README.md"
echo "⚙️ Configuração: config/trinity_mcp_config.yaml"
echo "📋 Logs: logs/trinity_ai_agent.log e logs/mcp_server.log"
