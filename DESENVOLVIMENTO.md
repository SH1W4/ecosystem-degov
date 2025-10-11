# 🚀 Guia de Desenvolvimento - ESG Token Ecosystem
## Rust Backend

<div align="center">

**Guia Completo de Desenvolvimento para Backend ESG Token Ecosystem**

[![Development](https://img.shields.io/badge/development-active-brightgreen.svg)](https://github.com/SH1W4/esg-token-backend)
[![Contributing](https://img.shields.io/badge/contributing-welcome-blue.svg)](https://github.com/SH1W4/esg-token-backend)
[![Code Style](https://img.shields.io/badge/code%20style-rustfmt-orange.svg)](https://github.com/rust-lang/rustfmt)

</div>

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Configuração do Ambiente](#-configuração-do-ambiente)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Padrões de Código](#-padrões-de-código)
- [Testes](#-testes)
- [Documentação](#-documentação)
- [Deploy](#-deploy)
- [Contribuição](#-contribuição)

## 🎯 Visão Geral

O **ESG Token Ecosystem Rust Backend** é um backend de alta performance desenvolvido em Rust para tokenização de métricas ESG. Este guia fornece todas as informações necessárias para desenvolvimento, contribuição e manutenção do projeto.

### 🏷️ **Tecnologias Principais**
- **Rust 1.70+**: Linguagem de programação
- **Axum 0.7**: Web framework
- **SQLx 0.7**: Database toolkit
- **Tokio 1.0**: Async runtime
- **Serde 1.0**: Serialization framework

## 🛠️ Configuração do Ambiente

### Pré-requisitos

#### Sistema Operacional
- **Linux**: Ubuntu 20.04+ / CentOS 8+
- **Windows**: Windows 10+ / Windows Server 2019+
- **macOS**: macOS 10.15+

#### Ferramentas Necessárias
```bash
# Rust (via rustup)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# PostgreSQL
sudo apt-get install postgresql postgresql-contrib  # Ubuntu
brew install postgresql                            # macOS
# Windows: Download from https://www.postgresql.org/download/windows/

# Redis
sudo apt-get install redis-server                  # Ubuntu
brew install redis                                 # macOS
# Windows: Download from https://github.com/microsoftarchive/redis/releases

# Docker (opcional)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

#### Ferramentas de Desenvolvimento
```bash
# Instalar ferramentas Rust
rustup component add rustfmt clippy
cargo install cargo-watch cargo-tarpaulin cargo-audit
```

### Configuração Inicial

#### 1. Clone do Repositório
```bash
git clone https://github.com/SH1W4/esg-token-backend.git
cd esg-token-backend
```

#### 2. Configurar Variáveis de Ambiente
```bash
# Copiar arquivo de exemplo
cp .env.example .env

# Editar configurações
nano .env
```

#### 3. Configurar Banco de Dados
```bash
# Criar banco de dados
createdb esg_tokens

# Executar migrações
cargo run --bin migrate
```

#### 4. Instalar Dependências
```bash
# Instalar dependências Rust
cargo build

# Instalar dependências de desenvolvimento
cargo install cargo-watch cargo-tarpaulin cargo-audit
```

## 📁 Estrutura do Projeto

```
rust-backend/
├── src/                          # Código fonte
│   ├── main.rs                   # Ponto de entrada
│   ├── models/                   # Modelos de dados
│   │   ├── mod.rs
│   │   ├── esg_metrics.rs
│   │   ├── ai_models.rs
│   │   └── blockchain_models.rs
│   ├── services/                 # Serviços de negócio
│   │   ├── mod.rs
│   │   ├── esg_service.rs
│   │   ├── ai_service.rs
│   │   └── blockchain_service.rs
│   ├── ai/                       # Serviços de IA
│   │   ├── mod.rs
│   │   ├── computer_vision.rs
│   │   ├── nlp.rs
│   │   ├── predictions.rs
│   │   └── recommendations.rs
│   ├── blockchain/               # Integração blockchain
│   │   ├── mod.rs
│   │   ├── ethereum.rs
│   │   ├── polygon.rs
│   │   ├── celo.rs
│   │   └── xrpl.rs
│   ├── database/                 # Camada de dados
│   │   ├── mod.rs
│   │   ├── connection.rs
│   │   └── migrations.rs
│   └── utils/                    # Utilitários
│       ├── mod.rs
│       ├── validation.rs
│       └── logging.rs
├── tests/                        # Testes de integração
│   ├── common/
│   ├── api_tests.rs
│   └── database_tests.rs
├── migrations/                    # Migrações do banco
│   ├── 001_initial_schema.sql
│   └── 002_add_ai_tables.sql
├── docs/                         # Documentação
│   ├── api.md
│   ├── architecture.md
│   └── deployment.md
├── scripts/                      # Scripts utilitários
│   ├── setup.sh
│   ├── test.sh
│   └── deploy.sh
├── docker/                       # Configurações Docker
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── docker-compose.prod.yml
├── k8s/                         # Configurações Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── .env.example                 # Exemplo de variáveis
├── .gitignore                   # Arquivos ignorados
├── Cargo.toml                   # Dependências Rust
├── Cargo.lock                   # Lock file
├── README.md                    # Documentação principal
├── EAP.md                       # Plano de arquitetura
└── DESENVOLVIMENTO.md           # Este arquivo
```

## 📝 Padrões de Código

### Convenções de Nomenclatura

#### Estruturas e Enums
```rust
// PascalCase para estruturas
pub struct ESGMetrics {
    pub id: String,
    pub entity_id: String,
    pub score: f64,
}

// PascalCase para enums
pub enum EntityType {
    Company,
    Individual,
    Organization,
}
```

#### Funções e Variáveis
```rust
// snake_case para funções
pub async fn calculate_esg_score(metrics: &ESGMetrics) -> Result<f64> {
    // Implementação
}

// snake_case para variáveis
let carbon_footprint = 150.5;
let energy_efficiency = 0.85;
```

#### Constantes
```rust
// SCREAMING_SNAKE_CASE para constantes
pub const MAX_ESG_SCORE: f64 = 100.0;
pub const DEFAULT_CACHE_TTL: u64 = 3600;
```

### Estrutura de Código

#### Organização de Módulos
```rust
// main.rs
use esg_token_backend::{
    models::*,
    services::*,
    ai::*,
    blockchain::*,
    database::*,
};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Inicialização da aplicação
}
```

#### Tratamento de Erros
```rust
use anyhow::{Result, Context};

pub async fn process_esg_metrics(metrics: ESGMetrics) -> Result<ESGMetrics> {
    // Validação
    validate_metrics(&metrics)
        .context("Failed to validate ESG metrics")?;
    
    // Processamento
    let processed_metrics = esg_service
        .calculate_score(&metrics)
        .await
        .context("Failed to calculate ESG score")?;
    
    Ok(processed_metrics)
}
```

#### Logging
```rust
use tracing::{info, warn, error, debug};

#[tracing::instrument]
pub async fn create_metrics(request: CreateMetricsRequest) -> Result<ESGMetrics> {
    info!("Creating ESG metrics for entity: {}", request.entity_id);
    
    match esg_service.create_metrics(request).await {
        Ok(metrics) => {
            info!("ESG metrics created successfully: {}", metrics.id);
            Ok(metrics)
        }
        Err(e) => {
            error!("Failed to create ESG metrics: {}", e);
            Err(e)
        }
    }
}
```

### Documentação de Código

#### Documentação de Funções
```rust
/// Calcula o score ESG baseado nas métricas fornecidas
/// 
/// # Arguments
/// 
/// * `metrics` - As métricas ESG a serem processadas
/// 
/// # Returns
/// 
/// * `Result<f64>` - O score ESG calculado (0.0 a 100.0)
/// 
/// # Errors
/// 
/// * `ValidationError` - Se as métricas forem inválidas
/// * `CalculationError` - Se houver erro no cálculo
/// 
/// # Examples
/// 
/// ```rust
/// use esg_token_backend::models::*;
/// 
/// let metrics = ESGMetrics {
///     id: "test-123".to_string(),
///     entity_id: "company-456".to_string(),
///     score: 0.0,
/// };
/// 
/// let score = calculate_esg_score(&metrics).await?;
/// assert!(score >= 0.0 && score <= 100.0);
/// ```
pub async fn calculate_esg_score(metrics: &ESGMetrics) -> Result<f64> {
    // Implementação
}
```

#### Documentação de Estruturas
```rust
/// Representa métricas ESG de uma entidade
/// 
/// Esta estrutura contém todas as informações necessárias
/// para calcular o score ESG de uma entidade.
/// 
/// # Fields
/// 
/// * `id` - Identificador único das métricas
/// * `entity_id` - ID da entidade (empresa, indivíduo, etc.)
/// * `score` - Score ESG calculado (0.0 a 100.0)
/// * `timestamp` - Timestamp de criação
/// 
/// # Examples
/// 
/// ```rust
/// use esg_token_backend::models::ESGMetrics;
/// 
/// let metrics = ESGMetrics {
///     id: "metrics-123".to_string(),
///     entity_id: "company-456".to_string(),
///     score: 85.5,
///     timestamp: chrono::Utc::now(),
/// };
/// ```
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ESGMetrics {
    /// Identificador único das métricas
    pub id: String,
    
    /// ID da entidade
    pub entity_id: String,
    
    /// Score ESG calculado
    pub score: f64,
    
    /// Timestamp de criação
    pub timestamp: chrono::DateTime<chrono::Utc>,
}
```

## 🧪 Testes

### Estratégia de Testes

#### Testes Unitários
```rust
#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::*;
    
    #[tokio::test]
    async fn test_calculate_esg_score() {
        let metrics = ESGMetrics {
            id: "test-123".to_string(),
            entity_id: "company-456".to_string(),
            score: 0.0,
            timestamp: chrono::Utc::now(),
        };
        
        let score = calculate_esg_score(&metrics).await.unwrap();
        assert!(score >= 0.0 && score <= 100.0);
    }
    
    #[test]
    fn test_validate_metrics() {
        let valid_metrics = ESGMetrics {
            id: "test-123".to_string(),
            entity_id: "company-456".to_string(),
            score: 85.5,
            timestamp: chrono::Utc::now(),
        };
        
        assert!(validate_metrics(&valid_metrics).is_ok());
    }
}
```

#### Testes de Integração
```rust
// tests/api_tests.rs
use axum::{
    body::Body,
    http::{Request, StatusCode},
};
use tower::ServiceExt;

#[tokio::test]
async fn test_health_check() {
    let app = create_app().await;
    
    let request = Request::builder()
        .uri("/health")
        .body(Body::empty())
        .unwrap();
    
    let response = app.oneshot(request).await.unwrap();
    assert_eq!(response.status(), StatusCode::OK);
}

#[tokio::test]
async fn test_create_metrics() {
    let app = create_app().await;
    
    let metrics = CreateMetricsRequest {
        entity_id: "test-company".to_string(),
        score: 85.5,
    };
    
    let request = Request::builder()
        .method("POST")
        .uri("/api/v1/metrics")
        .header("content-type", "application/json")
        .body(Body::from(serde_json::to_string(&metrics).unwrap()))
        .unwrap();
    
    let response = app.oneshot(request).await.unwrap();
    assert_eq!(response.status(), StatusCode::CREATED);
}
```

#### Testes de Performance
```rust
// tests/performance_tests.rs
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn benchmark_esg_calculation(c: &mut Criterion) {
    c.bench_function("esg_calculation", |b| {
        b.iter(|| {
            let metrics = create_test_metrics();
            black_box(calculate_esg_score(&metrics))
        })
    });
}

criterion_group!(benches, benchmark_esg_calculation);
criterion_main!(benches);
```

### Executando Testes

#### Comandos de Teste
```bash
# Executar todos os testes
cargo test

# Executar testes específicos
cargo test test_calculate_esg_score

# Executar testes com output detalhado
cargo test -- --nocapture

# Executar testes de integração
cargo test --test integration

# Executar testes de performance
cargo test --test performance
```

#### Cobertura de Testes
```bash
# Instalar ferramenta de cobertura
cargo install cargo-tarpaulin

# Executar testes com cobertura
cargo tarpaulin --out html

# Visualizar relatório
open tarpaulin-report.html
```

## 📚 Documentação

### Geração de Documentação

#### Documentação da API
```bash
# Gerar documentação
cargo doc --open

# Gerar documentação com dependências
cargo doc --all-features --open
```

#### Documentação Externa
```bash
# Instalar ferramenta de documentação
cargo install cargo-doc

# Gerar documentação completa
cargo doc --all-features --no-deps
```

### Estrutura da Documentação

#### README.md
- Visão geral do projeto
- Instruções de instalação
- Exemplos de uso
- Links para documentação detalhada

#### API Documentation
- Endpoints disponíveis
- Parâmetros de entrada
- Respostas esperadas
- Exemplos de uso

#### Architecture Documentation
- Arquitetura do sistema
- Diagramas de componentes
- Fluxo de dados
- Decisões de design

## 🚀 Deploy

### Ambientes de Deploy

#### Development
```bash
# Executar em modo desenvolvimento
cargo run

# Executar com hot reload
cargo watch -x run
```

#### Staging
```bash
# Build para staging
cargo build --release

# Executar testes
cargo test

# Deploy para staging
./scripts/deploy.sh staging
```

#### Production
```bash
# Build para produção
cargo build --release --features production

# Executar testes completos
cargo test --all-features

# Deploy para produção
./scripts/deploy.sh production
```

### Docker

#### Dockerfile
```dockerfile
FROM rust:1.70-slim as builder

WORKDIR /app
COPY . .

RUN cargo build --release

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/esg-token-backend /usr/local/bin/

EXPOSE 3000

CMD ["esg-token-backend"]
```

#### Docker Compose
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/esg_tokens
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: esg_tokens
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:6-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Kubernetes

#### Deployment
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
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

## 🤝 Contribuição

### Processo de Contribuição

#### 1. Fork do Repositório
```bash
# Fork no GitHub
# Clone do seu fork
git clone https://github.com/SEU_USUARIO/esg-token-backend.git
cd esg-token-backend
```

#### 2. Configurar Remote
```bash
# Adicionar remote original
git remote add upstream https://github.com/SH1W4/esg-token-backend.git

# Verificar remotes
git remote -v
```

#### 3. Criar Branch
```bash
# Criar branch para feature
git checkout -b feature/nova-funcionalidade

# Ou para bugfix
git checkout -b fix/corrigir-bug
```

#### 4. Desenvolvimento
```bash
# Fazer alterações
# Adicionar testes
# Executar testes
cargo test

# Verificar formatação
cargo fmt

# Verificar linting
cargo clippy
```

#### 5. Commit e Push
```bash
# Adicionar arquivos
git add .

# Commit com mensagem descritiva
git commit -m "feat: adicionar nova funcionalidade ESG"

# Push para seu fork
git push origin feature/nova-funcionalidade
```

#### 6. Pull Request
- Abrir Pull Request no GitHub
- Descrever as mudanças
- Referenciar issues relacionadas
- Aguardar review

### Padrões de Commit

#### Formato de Mensagem
```
tipo(escopo): descrição

Corpo da mensagem (opcional)

Rodapé (opcional)
```

#### Tipos de Commit
- **feat**: Nova funcionalidade
- **fix**: Correção de bug
- **docs**: Documentação
- **style**: Formatação
- **refactor**: Refatoração
- **test**: Testes
- **chore**: Tarefas de manutenção

#### Exemplos
```bash
# Nova funcionalidade
git commit -m "feat(esg): adicionar cálculo de score ESG"

# Correção de bug
git commit -m "fix(api): corrigir validação de parâmetros"

# Documentação
git commit -m "docs: atualizar guia de desenvolvimento"

# Testes
git commit -m "test: adicionar testes para AI service"
```

### Code Review

#### Checklist de Review
- [ ] Código segue padrões estabelecidos
- [ ] Testes cobrem as mudanças
- [ ] Documentação atualizada
- [ ] Performance não degradada
- [ ] Segurança mantida
- [ ] Compatibilidade preservada

#### Critérios de Aprovação
- 2+ aprovações de maintainers
- Todos os testes passando
- Cobertura de testes mantida
- Sem conflitos de merge

## 🔧 Ferramentas de Desenvolvimento

### IDE e Editores

#### VS Code
```json
// .vscode/settings.json
{
    "rust-analyzer.checkOnSave.command": "clippy",
    "rust-analyzer.cargo.features": "all",
    "editor.formatOnSave": true,
    "editor.rulers": [100]
}
```

#### Extensões Recomendadas
- **rust-analyzer**: Suporte completo para Rust
- **CodeLLDB**: Debugger para Rust
- **Better TOML**: Suporte para Cargo.toml
- **GitLens**: Integração com Git

### Ferramentas de Qualidade

#### Clippy (Linter)
```bash
# Executar clippy
cargo clippy

# Executar clippy com todas as regras
cargo clippy -- -W clippy::all
```

#### Rustfmt (Formatador)
```bash
# Formatar código
cargo fmt

# Verificar formatação
cargo fmt -- --check
```

#### Cargo Audit (Segurança)
```bash
# Verificar vulnerabilidades
cargo audit
```

### Monitoramento

#### Logs
```rust
use tracing::{info, warn, error};

// Configurar logging
tracing_subscriber::fmt()
    .with_env_filter("esg_token_backend=debug")
    .init();

// Usar logging
info!("Aplicação iniciada");
warn!("Configuração não encontrada");
error!("Erro crítico: {}", error);
```

#### Métricas
```rust
use prometheus::{Counter, Histogram, Registry};

// Definir métricas
lazy_static! {
    static ref REQUEST_COUNT: Counter = Counter::new(
        "http_requests_total",
        "Total number of HTTP requests"
    ).unwrap();
    
    static ref REQUEST_DURATION: Histogram = Histogram::new(
        "http_request_duration_seconds",
        "HTTP request duration in seconds"
    ).unwrap();
}
```

## 📊 Performance

### Benchmarks

#### Cargo Bench
```rust
// benches/performance.rs
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn benchmark_esg_calculation(c: &mut Criterion) {
    c.bench_function("esg_calculation", |b| {
        b.iter(|| {
            let metrics = create_test_metrics();
            black_box(calculate_esg_score(&metrics))
        })
    });
}

criterion_group!(benches, benchmark_esg_calculation);
criterion_main!(benches);
```

#### Executar Benchmarks
```bash
# Executar benchmarks
cargo bench

# Executar benchmark específico
cargo bench esg_calculation
```

### Otimizações

#### Compilação Otimizada
```toml
# Cargo.toml
[profile.release]
opt-level = 3
lto = true
codegen-units = 1
panic = "abort"
```

#### Runtime Otimizado
```rust
// Pool de conexões otimizado
let pool = PgPool::builder()
    .max_connections(100)
    .min_connections(10)
    .acquire_timeout(Duration::from_secs(30))
    .build(&database_url)
    .await?;

// Cache otimizado
let cache = redis::Client::open(redis_url)?
    .get_connection()?;
```

## 🐛 Debugging

### Debug Local
```bash
# Executar com debug
RUST_LOG=debug cargo run

# Executar com trace
RUST_LOG=trace cargo run
```

### Debug Remoto
```bash
# Instalar ferramenta de debug
cargo install cargo-debug

# Executar com debug
cargo debug
```

### Profiling
```bash
# Instalar ferramenta de profiling
cargo install cargo-profdata

# Executar profiling
cargo profdata
```

## 📈 Monitoramento

### Health Checks
```rust
// health.rs
pub async fn health_check() -> Result<Json<HealthResponse>> {
    // Verificar banco de dados
    let db_healthy = check_database().await?;
    
    // Verificar Redis
    let redis_healthy = check_redis().await?;
    
    // Verificar blockchain
    let blockchain_healthy = check_blockchain().await?;
    
    Ok(Json(HealthResponse {
        status: if db_healthy && redis_healthy && blockchain_healthy {
            "healthy"
        } else {
            "unhealthy"
        },
        services: vec![
            ("database", db_healthy),
            ("redis", redis_healthy),
            ("blockchain", blockchain_healthy),
        ],
    }))
}
```

### Métricas
```rust
// metrics.rs
use prometheus::{Counter, Histogram, Registry};

pub struct Metrics {
    pub request_count: Counter,
    pub request_duration: Histogram,
    pub esg_calculations: Counter,
}

impl Metrics {
    pub fn new() -> Self {
        Self {
            request_count: Counter::new(
                "http_requests_total",
                "Total number of HTTP requests"
            ).unwrap(),
            request_duration: Histogram::new(
                "http_request_duration_seconds",
                "HTTP request duration in seconds"
            ).unwrap(),
            esg_calculations: Counter::new(
                "esg_calculations_total",
                "Total number of ESG calculations"
            ).unwrap(),
        }
    }
}
```

## 🔒 Segurança

### Validação de Entrada
```rust
use validator::{Validate, ValidationError};

#[derive(Debug, Validate)]
pub struct CreateMetricsRequest {
    #[validate(length(min = 1, max = 255))]
    pub entity_id: String,
    
    #[validate(range(min = 0.0, max = 100.0))]
    pub score: f64,
}

pub async fn create_metrics(
    Json(request): Json<CreateMetricsRequest>
) -> Result<Json<ESGMetrics>, StatusCode> {
    // Validar entrada
    if let Err(errors) = request.validate() {
        return Err(StatusCode::BAD_REQUEST);
    }
    
    // Processar requisição
    // ...
}
```

### Autenticação
```rust
use jsonwebtoken::{decode, encode, Header, Algorithm, Validation};

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: usize,
    pub iat: usize,
    pub role: String,
}

pub fn create_jwt(user_id: &str, role: &str) -> Result<String> {
    let claims = Claims {
        sub: user_id.to_string(),
        exp: (chrono::Utc::now() + chrono::Duration::hours(24)).timestamp() as usize,
        iat: chrono::Utc::now().timestamp() as usize,
        role: role.to_string(),
    };
    
    let token = encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(jwt_secret.as_ref())
    )?;
    
    Ok(token)
}
```

## 📚 Recursos Adicionais

### Documentação Oficial
- [Rust Book](https://doc.rust-lang.org/book/)
- [Axum Documentation](https://docs.rs/axum/)
- [SQLx Documentation](https://docs.rs/sqlx/)
- [Tokio Documentation](https://docs.rs/tokio/)

### Comunidade
- [Rust Discord](https://discord.gg/rust-lang)
- [Rust Reddit](https://reddit.com/r/rust)
- [Rust Users Forum](https://users.rust-lang.org/)

### Ferramentas
- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [Clippy](https://github.com/rust-lang/rust-clippy)
- [Rustfmt](https://github.com/rust-lang/rustfmt)

---

<div align="center">

**ESG Token Ecosystem - Guia de Desenvolvimento**

*Version 1.0.0 | Last Updated: 2024-10-10*

Made with 🦀 by SH1W4 | High-performance ESG tokenization backend!

</div>


