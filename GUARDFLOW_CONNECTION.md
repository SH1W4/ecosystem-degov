# 🔗 **GUARDFLOW CONNECTION - LIGAÇÃO ENTRE REPOSITÓRIOS**

## 📋 **VISÃO GERAL DA CONEXÃO**

Este documento estabelece as **ligações funcionais** entre o **GuardFlow** e o **Ecosystem-Degov** após a migração dos arquivos ESG.

### **🎯 Objetivo da Conexão**
- **Manter** funcionalidade do GuardFlow
- **Integrar** com Ecosystem-Degov
- **Preservar** dados ESG migrados
- **Estabelecer** comunicação entre sistemas

---

## 🏗️ **ARQUITETURA DE CONEXÃO**

### **Fluxo de Integração:**
```mermaid
graph TB
    A[GuardFlow Frontend] --> B[GuardFlow Backend]
    B --> C[API Gateway]
    C --> D[Ecosystem-Degov Backend]
    D --> E[Blockchain Networks]
    D --> F[AI/ML Services]
    
    B --> G[Event Bus]
    G --> H[Token Generation]
    H --> I[ESG Calculation]
    I --> J[Reward Distribution]
    
    K[Migrated Files] --> L[Integration Layer]
    L --> M[Unified Services]
```

### **Componentes de Conexão:**
- **API Gateway**: Roteamento de requisições
- **Event Bus**: Comunicação assíncrona
- **Shared Services**: Serviços compartilhados
- **Data Sync**: Sincronização de dados

---

## 📁 **ESTRUTURA DE ARQUIVOS MIGRADOS**

### **Localização dos Arquivos:**
```
ecosystem-degov/
├── migration_from_guardflow/
│   ├── EAP_GUARDFLOW.md
│   ├── ECOSYSTEM_ARCHITECTURE_GUARDFLOW.md
│   ├── REORGANIZATION_GUIDE.md
│   ├── MIGRATION_LOG.md
│   └── src/
│       └── mobility/
│           ├── mod_guardflow.rs
│           └── cross_platform_guardflow.rs
```

### **Arquivos Originais (Preservados):**
```
ecosystem-degov/
├── src/
│   └── mobility/
│       ├── mod.rs (original)
│       └── cross_platform.rs (original)
```

---

## 🔌 **ENDPOINTS DE INTEGRAÇÃO**

### **GuardFlow → Ecosystem-Degov:**
```bash
# ESG Token Generation
POST /api/v1/esg/tokenize
{
  "transaction_id": "TXN-123",
  "esg_metrics": {...},
  "user_id": "USER-456"
}

# Token Balance Check
GET /api/v1/tokens/balance/{user_id}

# Cross-Platform Transfer
POST /api/v1/tokens/transfer
{
  "from_user": "USER-123",
  "to_user": "USER-456",
  "amount": 1000,
  "token_type": "ECT"
}
```

### **Ecosystem-Degov → GuardFlow:**
```bash
# ESG Score Update
POST /api/v1/esg/update-score
{
  "user_id": "USER-123",
  "new_score": 85.5,
  "tokens_earned": 150
}

# Token Transaction
POST /api/v1/tokens/transaction
{
  "transaction_id": "TXN-123",
  "token_amount": 1000,
  "blockchain_hash": "0x..."
}
```

---

## 📊 **DADOS COMPARTILHADOS**

### **Estruturas de Dados Migradas:**
```rust
// GuardFlow (Migrado)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CrossPlatformBalance {
    pub user_id: String,
    pub mobility_tokens: u64,        // ← Genérico
    pub sustainability_tokens: u64,  // ← Genérico
    pub total_unified_tokens: u64,
    pub cross_platform_multiplier: f64,
}

// Ecosystem-Degov (Original)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CrossPlatformBalance {
    pub user_id: String,
    pub guardrive_tokens: u64,    // ← Específico para GuardDrive
    pub guardflow_tokens: u64,    // ← Específico para GuardFlow
    pub total_unified_tokens: u64,
    pub cross_platform_multiplier: f64,
}
```

---

## 🔄 **FLUXO DE INTEGRAÇÃO**

### **1. Compra no GuardFlow:**
1. Usuário faz compra
2. GuardFlow calcula ESG score
3. Envia dados para Ecosystem-Degov
4. Ecosystem-Degov gera tokens
5. Retorna confirmação para GuardFlow

### **2. Tokenização ESG:**
1. Ecosystem-Degov recebe métricas ESG
2. Processa com AI/ML
3. Gera tokens correspondentes
4. Atualiza blockchain
5. Notifica GuardFlow

### **3. Cross-Platform Transfer:**
1. Usuário solicita transferência
2. Ecosystem-Degov valida
3. Executa transferência
4. Atualiza saldos
5. Confirma para GuardFlow

---

## 🛠️ **CONFIGURAÇÃO DE INTEGRAÇÃO**

### **Environment Variables:**
```bash
# Ecosystem-Degov
ECOSYSTEM_API_URL=http://localhost:3000
ECOSYSTEM_API_KEY=your-api-key
BLOCKCHAIN_NETWORK=ethereum
AI_SERVICE_URL=http://localhost:3001

# GuardFlow
GUARDFLOW_API_URL=http://localhost:8002
GUARDFLOW_API_KEY=your-api-key
INTEGRATION_MODE=production
```

### **API Gateway Configuration:**
```yaml
api_gateway:
  version: "v1"
  base_url: "https://api.guardflow.com"
  
  services:
    guardflow:
      path: "/api/v1/guardflow"
      upstream: "http://localhost:8002"
      rate_limit: "1000/hour"
    
    ecosystem:
      path: "/api/v1/ecosystem"
      upstream: "http://localhost:3000"
      rate_limit: "500/hour"
```

---

## 🧪 **TESTING DE INTEGRAÇÃO**

### **Testes Automatizados:**
```bash
# Testar integração GuardFlow → Ecosystem-Degov
curl -X POST http://localhost:8002/api/v1/integration/test \
  -H "Content-Type: application/json" \
  -d '{"test_type": "esg_tokenization"}'

# Testar integração Ecosystem-Degov → GuardFlow
curl -X POST http://localhost:3000/api/v1/integration/test \
  -H "Content-Type: application/json" \
  -d '{"test_type": "token_balance"}'
```

### **Testes de Carga:**
```bash
# Teste de carga na integração
artillery run integration-load-test.yml
```

---

## 📈 **MONITORAMENTO**

### **Métricas de Integração:**
- **API Response Time**: < 200ms
- **Integration Success Rate**: > 99%
- **Token Generation Time**: < 5s
- **Cross-Platform Transfer**: < 10s

### **Dashboards:**
- **GuardFlow Dashboard**: Métricas de checkout
- **Ecosystem Dashboard**: Métricas de tokenização
- **Integration Dashboard**: Métricas de integração

---

## 🚀 **DEPLOYMENT**

### **Desenvolvimento:**
```bash
# Iniciar GuardFlow
cd GuardFlow/backend
uvicorn app.main:app --host 127.0.0.1 --port 8002

# Iniciar Ecosystem-Degov
cd ecosystem-degov
cargo run --bin ecosystem-degov
```

### **Produção:**
```bash
# Docker Compose
docker-compose up -d

# Kubernetes
kubectl apply -f k8s/
```

---

## 🔧 **TROUBLESHOOTING**

### **Problemas Comuns:**
1. **API Connection Failed**: Verificar URLs e chaves
2. **Token Generation Failed**: Verificar blockchain connection
3. **Data Sync Issues**: Verificar Event Bus
4. **Performance Issues**: Verificar rate limits

### **Logs:**
```bash
# GuardFlow logs
tail -f GuardFlow/backend/logs/app.log

# Ecosystem-Degov logs
tail -f ecosystem-degov/logs/ecosystem.log
```

---

## 📚 **DOCUMENTAÇÃO ADICIONAL**

- **Migration Log**: `migration_from_guardflow/MIGRATION_LOG.md`
- **Integration Guide**: `GUARDFLOW_INTEGRATION.md`
- **API Reference**: `/docs/api-reference.md`

---

**🔗 Conexão GuardFlow ↔ Ecosystem-Degov - Ecossistema ESG Unificado! 🌱**
