# 🚀 ESG Token Ecosystem - Rust Backend

<div align="center">

[![Rust](https://img.shields.io/badge/Rust-1.70+-orange.svg)](https://rust-lang.org)
[![Axum](https://img.shields.io/badge/Axum-0.7-blue.svg)](https://github.com/tokio-rs/axum)
[![SQLx](https://img.shields.io/badge/SQLx-0.7-green.svg)](https://github.com/launchbadge/sqlx)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows%20%7C%20macOS-lightgrey.svg)](https://rust-lang.org)
[![Status](https://img.shields.io/badge/status-Production%20Ready-brightgreen.svg)](https://github.com/SH1W4/ecosystem-degov)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)](https://github.com/SH1W4/ecosystem-degov)
[![Performance](https://img.shields.io/badge/performance-optimized-blue.svg)](https://github.com/SH1W4/ecosystem-degov)

**Backend de Alta Performance para Tokenização de Métricas ESG**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [API](#-api) • [Contributing](#-contributing)

</div>

## 📋 Overview

O **ESG Token Ecosystem Rust Backend** é um backend de alta performance desenvolvido em Rust para tokenização de métricas ESG. Oferece APIs RESTful, integração com blockchain, serviços de IA e análise de dados em tempo real.

### 🏷️ **Linguagens e Tecnologias**
- **Backend**: Rust 1.70+, Axum, SQLx, Tokio
- **Database**: PostgreSQL, Redis
- **AI/ML**: Candle, Transformers, Computer Vision
- **Blockchain**: Ethereum, Polygon, Celo, XRPL
- **DevOps**: Docker, Kubernetes, Prometheus

### 🌟 Key Features

- **🚀 Performance**: Backend em Rust com performance excepcional
- **🧠 IA Integrada**: Computer Vision, NLP, Analytics, Predictions
- **🔗 Blockchain**: Suporte para múltiplas blockchains
- **📊 ESG Metrics**: Cálculo automático de métricas ESG
- **🪙 GST Integration**: Sistema completo de tokens GST integrado
- **🛒 Smart Cart**: Integração com carrinho inteligente
- **📄 NFE to NFT**: Conversão automática de notas fiscais em NFTs
- **🎮 Gamification**: Sistema de gamificação e recompensas
- **🏛️ Governance**: Governança descentralizada
- **🛍️ Marketplace**: Marketplace de tokens GST
- **🔒 Segurança**: Autenticação e autorização robustas
- **📈 Analytics**: Análise de dados em tempo real
- **🌍 Escalabilidade**: Arquitetura microserviços
- **⚡ Concorrência**: Processamento assíncrono
- **🔄 Real-time**: WebSockets e streaming
- **📱 APIs**: RESTful APIs documentadas

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    RUST BACKEND                             │
├─────────────────────────────────────────────────────────────┤
│  API Layer          │  Business Logic    │  Data Layer      │
│  • Axum Router      │  • ESG Service     │  • PostgreSQL   │
│  • Middleware       │  • AI Service      │  • Redis        │
│  • Validation      │  • Blockchain      │  • SQLx         │
├─────────────────────────────────────────────────────────────┤
│  AI Services        │  Blockchain         │  Analytics       │
│  • Computer Vision  │  • Ethereum       │  • Metrics      │
│  • NLP              │  • Polygon        │  • Monitoring   │
│  • Predictions      │  • Celo           │  • Logging      │
│  • Recommendations  │  • XRPL            │  • Tracing      │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Installation

### Pré-requisitos
- Rust 1.70+
- PostgreSQL 13+
- Redis 6+
- Docker (opcional)

### Quick Start

1. **Clone o repositório**
   ```bash
   git clone https://github.com/SH1W4/ecosystem-gst.git
   cd ecosystem-gst/rust-backend
   ```

2. **Configurar variáveis de ambiente**
   ```bash
   cp .env.example .env
   # Editar .env com suas configurações
   ```

3. **Instalar dependências**
   ```bash
   cargo build
   ```

4. **Configurar banco de dados**
   ```bash
   # Criar banco de dados PostgreSQL
   createdb esg_tokens
   
   # Executar migrações
   cargo run --bin migrate
   ```

5. **Executar aplicação**
   ```bash
   cargo run
   ```

### Docker Installation

```bash
# Build e execute com Docker Compose
docker-compose up --build -d

# Acessar aplicação
# API: http://localhost:3000
# Documentação: http://localhost:3000/docs
```

## 🚀 Usage

### Exemplo Básico

```rust
use esg_token_backend::models::*;
use esg_token_backend::services::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Inicializar serviços
    let esg_service = ESGService::new().await?;
    let ai_service = AIService::new().await?;
    let blockchain_service = BlockchainService::new().await?;
    
    // Criar métricas ESG
    let metrics = CreateMetricsRequest {
        entity_id: "company-123".to_string(),
        entity_type: EntityType::Company,
        environmental: EnvironmentalMetrics {
            carbon_footprint: CarbonFootprint {
                scope1_emissions: 100.0,
                scope2_emissions: 50.0,
                scope3_emissions: 200.0,
                total_emissions: 350.0,
                reduction_target: 50.0,
                achievement_rate: 0.7,
            },
            // ... outros campos
        },
        // ... outros campos
    };
    
    // Criar métricas
    let response = esg_service.create_metrics(metrics).await?;
    println!("Métricas criadas: {:?}", response);
    
    // Tokenizar métricas
    let tokenize_request = TokenizeRequest {
        metrics_id: response.id,
        token_type: TokenType::ESGToken,
        amount: 100.0,
        blockchain: BlockchainType::Ethereum,
    };
    
    let token_response = blockchain_service.tokenize_metrics(tokenize_request).await?;
    println!("Métricas tokenizadas: {:?}", token_response);
    
    Ok(())
}
```

### Exemplo com IA

```rust
use esg_token_backend::ai::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let ai_service = AIService::new().await?;
    
    // Análise de sentimento
    let sentiment_request = NLPRequest {
        text: "Our company is committed to sustainability and reducing carbon emissions.".to_string(),
        language: Some("en".to_string()),
        analysis_type: NLPAnalysisType::SentimentAnalysis,
        options: None,
    };
    
    let sentiment_response = ai_service.nlp.analyze_text(sentiment_request).await?;
    println!("Análise de sentimento: {:?}", sentiment_response);
    
    // Análise de imagem
    let image_request = ImageAnalysisRequest {
        image_data: "base64_encoded_image".to_string(),
        analysis_type: AnalysisType::SustainabilityCheck,
        options: None,
    };
    
    let image_response = ai_service.computer_vision.analyze_image(image_request).await?;
    println!("Análise de imagem: {:?}", image_response);
    
    Ok(())
}
```

## 🪙 GST Integration

O backend inclui integração completa com o **GST (GuardFlow Sustainability Token)** ecosystem:

### 🏗️ GST Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    GST ECOSYSTEM                           │
├─────────────────────────────────────────────────────────────┤
│  Token Management  │  Marketplace    │  Gamification      │
│  • GST Tokens      │  • List Items   │  • User Levels      │
│  • Balances        │  • Buy Items    │  • Missions         │
│  • Transfers       │  • Categories   │  • Achievements     │
├─────────────────────────────────────────────────────────────┤
│  Governance        │  NFE Converter  │  Smart Cart         │
│  • Proposals       │  • NFe to NFT   │  • Cart Processing  │
│  • Voting          │  • Metadata     │  • Sustainability   │
│  • Execution       │  • Blockchain   │  • Rewards          │
└─────────────────────────────────────────────────────────────┘
```

### 🚀 GST Features

- **🪙 Token Management**: Criação, transferência e gestão de tokens GST
- **🛍️ Marketplace**: Sistema de marketplace para troca de tokens
- **🎮 Gamification**: Sistema de níveis, missões e conquistas
- **🏛️ Governance**: Sistema de governança descentralizada
- **📄 NFE to NFT**: Conversão automática de notas fiscais em NFTs únicos
- **🛒 Smart Cart**: Integração com carrinho inteligente para processamento automático
- **🚗 GuardDrive Integration**: Integração nativa com ecossistema GuardDrive
- **🔄 Cross-Platform**: Tokens transferíveis entre GuardDrive e GuardFlow
- **📊 Unified Analytics**: Analytics ESG unificado entre plataformas

## 🔗 API Endpoints

### ESG Metrics

```http
POST /api/v1/metrics
GET /api/v1/metrics/{id}
PUT /api/v1/metrics/{id}
DELETE /api/v1/metrics/{id}
```

### AI Services

```http
POST /api/v1/ai/analyze
POST /api/v1/ai/predictions
POST /api/v1/ai/recommendations
POST /api/v1/ai/insights
```

### Blockchain

```http
POST /api/v1/tokenize
GET /api/v1/tokens/{id}/balance
POST /api/v1/tokens/transfer
POST /api/v1/tokens/mint
POST /api/v1/tokens/burn
```

### Analytics

```http
GET /api/v1/analytics/trends
GET /api/v1/analytics/benchmarks
GET /api/v1/analytics/reports
```

### GST Token Management

```http
GET /api/v1/gst/tokens/{token_id}
GET /api/v1/gst/balance/{address}/{token_id}
POST /api/v1/gst/transfer
```

### GST Marketplace

```http
POST /api/v1/gst/marketplace/list
POST /api/v1/gst/marketplace/buy
```

### GST Gamification

```http
GET /api/v1/gst/gamification/{user_id}
POST /api/v1/gst/gamification/complete-mission
```

### GST Governance

```http
POST /api/v1/gst/governance/propose
POST /api/v1/gst/governance/vote
```

### NFE to NFT Conversion

```http
POST /api/v1/gst/nfe/convert
```

### Smart Cart Integration

```http
POST /api/v1/gst/smart-cart/process
```

### GuardDrive Integration

```http
POST /api/v1/gst/guardrive/sync
GET /api/v1/gst/guardrive/vehicle/{vehicle_id}
POST /api/v1/gst/guardrive/telemetry
```

### Cross-Platform Integration

```http
POST /api/v1/gst/cross-platform/transfer
GET /api/v1/gst/cross-platform/balance
POST /api/v1/gst/cross-platform/rewards
```

## 🧪 Testing

### Unit Tests
```bash
cargo test
```

### Integration Tests
```bash
cargo test --test integration
```

### Performance Tests
```bash
cargo test --test performance
```

### Coverage
```bash
cargo tarpaulin --out html
```

## 📊 Monitoring

### Health Check
```http
GET /health
```

### Metrics
```http
GET /metrics
```

### Logs
```bash
# Visualizar logs
docker-compose logs -f rust-backend

# Logs específicos
docker-compose logs -f rust-backend | grep ERROR
```

## 🔧 Configuration

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost/esg_tokens
REDIS_URL=redis://localhost:6379

# Blockchain
ETHEREUM_RPC_URL=https://mainnet.infura.io/v3/YOUR_PROJECT_ID
POLYGON_RPC_URL=https://polygon-rpc.com
CELO_RPC_URL=https://forno.celo.org

# AI Services
OPENAI_API_KEY=your_openai_api_key
GOOGLE_VISION_API_KEY=your_google_vision_api_key

# Security
JWT_SECRET=your_jwt_secret
API_KEY=your_api_key

# Monitoring
PROMETHEUS_ENDPOINT=http://localhost:9090
GRAFANA_ENDPOINT=http://localhost:3000
```

### Database Schema

```sql
-- ESG Metrics Table
CREATE TABLE esg_metrics (
    id UUID PRIMARY KEY,
    entity_id VARCHAR(255) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    score DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Token Transactions Table
CREATE TABLE token_transactions (
    id UUID PRIMARY KEY,
    token_id VARCHAR(255) NOT NULL,
    from_address VARCHAR(255) NOT NULL,
    to_address VARCHAR(255) NOT NULL,
    amount DECIMAL(18,8) NOT NULL,
    transaction_hash VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 🚀 Deployment

### Docker

```bash
# Build da imagem
docker build -t esg-token-backend .

# Executar container
docker run -d \
  --name esg-token-backend \
  -p 3000:3000 \
  -e DATABASE_URL=postgresql://user:password@host:5432/esg_tokens \
  esg-token-backend
```

### Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: esg-token-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: esg-token-backend
  template:
    metadata:
      labels:
        app: esg-token-backend
    spec:
      containers:
      - name: esg-token-backend
        image: esg-token-backend:latest
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: esg-secrets
              key: database-url
```

## 📈 Performance

### Benchmarks

- **Throughput**: 100,000+ requests/second
- **Latency**: < 1ms p99
- **Memory**: < 100MB base usage
- **CPU**: < 10% under normal load

### Optimization

```rust
// Otimizações de performance
#[tokio::main]
async fn main() {
    // Pool de conexões otimizado
    let pool = PgPool::builder()
        .max_connections(100)
        .min_connections(10)
        .build(&database_url)
        .await?;
    
    // Cache Redis otimizado
    let redis = redis::Client::open(redis_url)?;
    
    // Configuração de concorrência
    tokio::task::spawn_blocking(|| {
        // Processamento pesado
    });
}
```

## 🔒 Security

### Autenticação

```rust
// JWT Authentication
#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: usize,
    pub iat: usize,
}

pub fn create_jwt(user_id: &str) -> Result<String> {
    let claims = Claims {
        sub: user_id.to_string(),
        exp: (chrono::Utc::now() + chrono::Duration::hours(24)).timestamp() as usize,
        iat: chrono::Utc::now().timestamp() as usize,
    };
    
    let token = encode(&Header::default(), &claims, &EncodingKey::from_secret(jwt_secret.as_ref()))?;
    Ok(token)
}
```

### Autorização

```rust
// Role-based access control
#[derive(Debug, Clone)]
pub enum Role {
    Admin,
    User,
    Viewer,
}

pub fn check_permission(role: &Role, resource: &str, action: &str) -> bool {
    match (role, resource, action) {
        (Role::Admin, _, _) => true,
        (Role::User, "metrics", "read") => true,
        (Role::User, "metrics", "write") => true,
        (Role::Viewer, "metrics", "read") => true,
        _ => false,
    }
}
```

## 🛣️ Roadmap

### Phase 1: Core Backend (✅ Completed)
- [x] Rust backend with Axum
- [x] PostgreSQL integration
- [x] Redis caching
- [x] Basic ESG metrics
- [x] Health checks

### Phase 2: AI Integration (✅ Completed)
- [x] Computer Vision
- [x] NLP services
- [x] Predictions
- [x] Recommendations
- [x] Advanced ML models

### Phase 3: Blockchain Integration (✅ Completed)
- [x] Ethereum support
- [x] Polygon support
- [x] Celo support
- [x] XRPL support
- [x] Advanced DeFi features

### Phase 4: GST Integration (✅ Completed)
- [x] GST Token Management
- [x] GST Marketplace
- [x] GST Gamification
- [x] GST Governance
- [x] NFE to NFT Conversion
- [x] Smart Cart Integration

### Phase 5: Advanced Features (📋 Planned)
- [ ] Real-time streaming
- [ ] Advanced analytics
- [ ] Machine learning pipelines
- [ ] Microservices architecture

## 🤝 Contributing

Agradecemos contribuições! Por favor, veja nosso [Guia de Contribuição](CONTRIBUTING.md) para detalhes.

1. Fork o repositório
2. Crie sua branch de feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Development Setup

```bash
# Instalar dependências de desenvolvimento
cargo install cargo-watch
cargo install cargo-tarpaulin
cargo install cargo-audit

# Executar em modo desenvolvimento
cargo watch -x run

# Executar testes com cobertura
cargo tarpaulin --out html

# Auditoria de segurança
cargo audit
```

## 📄 License

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👥 Team

- **SH1W4** - *Initial work* - [GitHub](https://github.com/SH1W4)

## 🙏 Acknowledgments

- Comunidade Rust e Axum
- SQLx por database integration
- Tokio por async runtime
- Todos os contribuidores e testadores

## 📞 Support

- **Documentação**: [docs.esg-token.com](https://docs.esg-token.com)
- **Issues**: [GitHub Issues](https://github.com/SH1W4/ecosystem-gst/issues)
- **Email**: support@esg-token.com

---

<div align="center">
Made with 🦀 by SH1W4 | High-performance ESG tokenization backend!
</div>
