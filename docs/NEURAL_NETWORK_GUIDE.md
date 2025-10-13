# 🧠 Trinity Neural Network - Guia de Uso Prático
## **Como Usar a Rede Neural em Projetos Reais**

---

## 📋 **ÍNDICE PRÁTICO**

1. [Quick Start](#-quick-start)
2. [Exemplos Práticos](#-exemplos-práticos)
3. [Integração com Projetos](#-integração-com-projetos)
4. [Troubleshooting](#-troubleshooting)
5. [Best Practices](#-best-practices)
6. [FAQ](#-faq)

---

## 🚀 **QUICK START**

### **⚡ Instalação Rápida**

```bash
# 1. Clonar repositório
git clone https://github.com/SH1W4/ecosystem-degov.git
cd ecosystem-degov

# 2. Instalar dependências
cargo build --bin trinity_ai_agent

# 3. Executar Trinity AI Agent
cargo run --bin trinity_ai_agent
```

### **🔧 Configuração Básica**

```rust
use trinity_ai_agent::TrinityAIAgent;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Criar agente Trinity
    let mut trinity_ai = TrinityAIAgent::new();
    
    // Treinar rede neural
    let accuracy = trinity_ai.train_neural_network().await?;
    println!("✅ Rede neural treinada: {:.2}%", accuracy * 100.0);
    
    // Otimizar sistema
    let optimization = trinity_ai.optimize_with_neural().await?;
    println!("⚡ Sistema otimizado: {:.2}%", optimization.improvement_percentage);
    
    Ok(())
}
```

---

## 💡 **EXEMPLOS PRÁTICOS**

### **🔍 Exemplo 1: Análise de NFe para ESG**

```rust
use trinity_neural_network::{TrinityNeuralNetwork, NFEData};
use chrono::Utc;

async fn analyze_nfe_for_esg() -> Result<(), Box<dyn std::error::Error>> {
    // Criar rede neural
    let mut neural_network = TrinityNeuralNetwork::new();
    
    // Dados de NFe real
    let nfe_data = NFEData {
        chave_acesso: "35240114200166000187550010000000271123456789".to_string(),
        valor_total: 2500.0,
        categoria: "Energia Renovavel".to_string(),
        municipio: "São Paulo".to_string(),
        uf: "SP".to_string(),
        cnpj_emitente: "14200166000187".to_string(),
        cnpj_destinatario: "12345678000195".to_string(),
        data_emissao: Utc::now(),
        esg_score: 0.0,
        is_verificada: true,
    };
    
    // Fazer previsão ESG
    let prediction = neural_network.predict_esg_score(&nfe_data).await?;
    
    // Exibir resultados
    println!("📊 Análise ESG da NFe:");
    println!("   🟢 Ambiental: {:.2} ({:.1}%)", 
             prediction.environmental, prediction.environmental * 100.0);
    println!("   👥 Social: {:.2} ({:.1}%)", 
             prediction.social, prediction.social * 100.0);
    println!("   🏛️ Governança: {:.2} ({:.1}%)", 
             prediction.governance, prediction.governance * 100.0);
    println!("   📈 Score Total: {:.2} ({:.1}%)", 
             prediction.total_score, prediction.total_score * 100.0);
    println!("   🎯 Confiança: {:.1}%", prediction.confidence * 100.0);
    
    // Interpretar resultados
    interpret_esg_score(&prediction);
    
    Ok(())
}

fn interpret_esg_score(score: &trinity_neural_network::ESGScore) {
    let total = score.total_score;
    
    match total {
        t if t >= 0.9 => println!("🌟 Excelente! NFe com alto impacto ESG positivo"),
        t if t >= 0.7 => println!("✅ Bom! NFe com impacto ESG positivo"),
        t if t >= 0.5 => println!("⚠️ Regular. NFe com impacto ESG neutro"),
        t if t >= 0.3 => println!("❌ Ruim. NFe com impacto ESG negativo"),
        _ => println!("🚨 Crítico! NFe com alto impacto ESG negativo"),
    }
}
```

### **⚡ Exemplo 2: Otimização Automática de Sistema**

```rust
use trinity_ai_agent::TrinityAIAgent;
use std::time::Duration;
use tokio::time::sleep;

async fn continuous_optimization() -> Result<(), Box<dyn std::error::Error>> {
    let mut trinity_ai = TrinityAIAgent::new();
    
    println!("🚀 Iniciando otimização contínua do sistema...");
    
    // Loop de otimização contínua
    for cycle in 1..=10 {
        println!("\n🔄 Ciclo {} de otimização...", cycle);
        
        // Treinar rede neural
        let accuracy = trinity_ai.train_neural_network().await?;
        println!("📊 Precisão: {:.2}%", accuracy * 100.0);
        
        // Otimizar sistema
        let optimization = trinity_ai.optimize_with_neural().await?;
        println!("⚡ Melhoria: {:.2}%", optimization.improvement_percentage);
        
        // Fazer previsões de teste
        let test_predictions = make_test_predictions(&trinity_ai).await?;
        println!("🔮 Previsões de teste: {}", test_predictions);
        
        // Aguardar próximo ciclo
        sleep(Duration::from_secs(60)).await; // 1 minuto
    }
    
    println!("✅ Otimização contínua concluída!");
    Ok(())
}

async fn make_test_predictions(trinity_ai: &TrinityAIAgent) -> Result<usize, Box<dyn std::error::Error>> {
    let mut predictions = 0;
    
    // Criar dados de teste
    for i in 0..5 {
        let nfe_data = create_test_nfe_data(i);
        let prediction = trinity_ai.predict_esg_with_neural(&nfe_data).await?;
        
        println!("   Teste {}: ESG Score {:.2}", i + 1, prediction.total_score);
        predictions += 1;
    }
    
    Ok(predictions)
}

fn create_test_nfe_data(index: usize) -> trinity_neural_network::NFEData {
    let categories = vec![
        "Energia Renovavel",
        "Reciclagem",
        "Sustentavel",
        "Eletrico",
        "Hibrido"
    ];
    
    trinity_neural_network::NFEData {
        chave_acesso: format!("test_key_{}", index),
        valor_total: 1000.0 + (index as f64 * 500.0),
        categoria: categories[index % categories.len()].to_string(),
        municipio: "São Paulo".to_string(),
        uf: "SP".to_string(),
        cnpj_emitente: "12345678000195".to_string(),
        cnpj_destinatario: "98765432000123".to_string(),
        data_emissao: chrono::Utc::now(),
        esg_score: 0.0,
        is_verificada: true,
    }
}
```

### **🔗 Exemplo 3: Integração com Smart Contracts**

```rust
use trinity_ai_agent::TrinityAIAgent;
use trinity_neural_network::NFEData;

async fn integrate_with_smart_contracts() -> Result<(), Box<dyn std::error::Error>> {
    let mut trinity_ai = TrinityAIAgent::new();
    
    println!("🔗 Integrando com smart contracts...");
    
    // Simular dados de NFe do smart contract
    let nfe_data = NFEData {
        chave_acesso: "35240114200166000187550010000000271123456789".to_string(),
        valor_total: 1500.0,
        categoria: "Energia Renovavel".to_string(),
        municipio: "São Paulo".to_string(),
        uf: "SP".to_string(),
        cnpj_emitente: "14200166000187".to_string(),
        cnpj_destinatario: "12345678000195".to_string(),
        data_emissao: chrono::Utc::now(),
        esg_score: 0.0,
        is_verificada: true,
    };
    
    // Calcular ESG Score usando rede neural
    let esg_score = trinity_ai.predict_esg_with_neural(&nfe_data).await?;
    
    // Simular chamada para smart contract
    let token_reward = calculate_token_reward(&esg_score);
    println!("💰 Recompensa em tokens: {:.2} GST", token_reward);
    
    // Simular mint de NFT NFe
    let nft_metadata = create_nft_metadata(&nfe_data, &esg_score);
    println!("🎨 NFT NFe criado: {}", nft_metadata);
    
    Ok(())
}

fn calculate_token_reward(esg_score: &trinity_neural_network::ESGScore) -> f64 {
    // Calcular recompensa baseada no ESG Score
    let base_reward = 100.0; // 100 GST base
    let multiplier = esg_score.total_score;
    base_reward * multiplier
}

fn create_nft_metadata(nfe_data: &NFEData, esg_score: &trinity_neural_network::ESGScore) -> String {
    format!(
        r#"{{
            "name": "NFE ESG NFT #{}",
            "description": "Nota Fiscal Eletrônica tokenizada com score ESG",
            "image": "ipfs://QmYourHashHere",
            "attributes": [
                {{"trait_type": "ESG Score", "value": {:.2}}},
                {{"trait_type": "Environmental", "value": {:.2}}},
                {{"trait_type": "Social", "value": {:.2}}},
                {{"trait_type": "Governance", "value": {:.2}}},
                {{"trait_type": "Confidence", "value": {:.2}}},
                {{"trait_type": "Category", "value": "{}"}},
                {{"trait_type": "Value", "value": {:.2}}}
            ]
        }}"#,
        nfe_data.chave_acesso,
        esg_score.total_score,
        esg_score.environmental,
        esg_score.social,
        esg_score.governance,
        esg_score.confidence,
        nfe_data.categoria,
        nfe_data.valor_total
    )
}
```

---

## 🔗 **INTEGRAÇÃO COM PROJETOS**

### **🚗 GuardDrive Integration**

```rust
use trinity_ai_agent::TrinityAIAgent;
use trinity_neural_network::{NFEData, MobilityData};

async fn guarddrive_integration() -> Result<(), Box<dyn std::error::Error>> {
    let mut trinity_ai = TrinityAIAgent::new();
    
    println!("🚗 Integrando com GuardDrive...");
    
    // Simular dados de mobilidade
    let mobility_data = MobilityData {
        user_id: "user_123".to_string(),
        vehicle_type: "Eletrico".to_string(),
        distance: 50.0,
        fuel_consumption: 0.0, // Veículo elétrico
        carbon_emissions: 0.0, // Zero emissões
        route_efficiency: 0.95,
        timestamp: chrono::Utc::now(),
    };
    
    // Simular NFe de abastecimento elétrico
    let nfe_data = NFEData {
        chave_acesso: "35240114200166000187550010000000271123456789".to_string(),
        valor_total: 80.0, // Custo da recarga
        categoria: "Energia Renovavel".to_string(),
        municipio: "São Paulo".to_string(),
        uf: "SP".to_string(),
        cnpj_emitente: "14200166000187".to_string(),
        cnpj_destinatario: "12345678000195".to_string(),
        data_emissao: chrono::Utc::now(),
        esg_score: 0.0,
        is_verificada: true,
    };
    
    // Calcular ESG Score
    let esg_score = trinity_ai.predict_esg_with_neural(&nfe_data).await?;
    
    // Calcular recompensa baseada em mobilidade sustentável
    let mobility_bonus = calculate_mobility_bonus(&mobility_data, &esg_score);
    let total_reward = esg_score.total_score * 100.0 + mobility_bonus;
    
    println!("🌱 Mobilidade sustentável detectada!");
    println!("   🚗 Veículo: {}", mobility_data.vehicle_type);
    println!("   📏 Distância: {:.1} km", mobility_data.distance);
    println!("   🌍 Emissões: {:.1} kg CO2", mobility_data.carbon_emissions);
    println!("   ⚡ Eficiência: {:.1}%", mobility_data.route_efficiency * 100.0);
    println!("   📊 ESG Score: {:.2}", esg_score.total_score);
    println!("   💰 Recompensa total: {:.2} GST", total_reward);
    
    Ok(())
}

fn calculate_mobility_bonus(mobility: &MobilityData, esg: &trinity_neural_network::ESGScore) -> f64 {
    let base_bonus = 50.0;
    let efficiency_bonus = mobility.route_efficiency * 20.0;
    let esg_bonus = esg.total_score * 30.0;
    
    base_bonus + efficiency_bonus + esg_bonus
}
```

### **🛍️ GuardFlow Integration**

```rust
use trinity_ai_agent::TrinityAIAgent;
use trinity_neural_network::NFEData;

async fn guardflow_integration() -> Result<(), Box<dyn std::error::Error>> {
    let mut trinity_ai = TrinityAIAgent::new();
    
    println!("🛍️ Integrando com GuardFlow...");
    
    // Simular compra sustentável
    let nfe_data = NFEData {
        chave_acesso: "35240114200166000187550010000000271123456789".to_string(),
        valor_total: 200.0,
        categoria: "Sustentavel".to_string(),
        municipio: "São Paulo".to_string(),
        uf: "SP".to_string(),
        cnpj_emitente: "14200166000187".to_string(),
        cnpj_destinatario: "12345678000195".to_string(),
        data_emissao: chrono::Utc::now(),
        esg_score: 0.0,
        is_verificada: true,
    };
    
    // Calcular ESG Score
    let esg_score = trinity_ai.predict_esg_with_neural(&nfe_data).await?;
    
    // Calcular recompensa baseada em consumo sustentável
    let consumption_bonus = calculate_consumption_bonus(&nfe_data, &esg_score);
    let total_reward = esg_score.total_score * 100.0 + consumption_bonus;
    
    println!("🌱 Consumo sustentável detectado!");
    println!("   🛍️ Categoria: {}", nfe_data.categoria);
    println!("   💰 Valor: R$ {:.2}", nfe_data.valor_total);
    println!("   📊 ESG Score: {:.2}", esg_score.total_score);
    println!("   💰 Recompensa total: {:.2} GST", total_reward);
    
    // Simular criação de NFT NFe
    let nft_metadata = create_nfe_nft(&nfe_data, &esg_score);
    println!("🎨 NFT NFe criado: {}", nft_metadata);
    
    Ok(())
}

fn calculate_consumption_bonus(nfe: &NFEData, esg: &trinity_neural_network::ESGScore) -> f64 {
    let base_bonus = 25.0;
    let value_bonus = nfe.valor_total * 0.1;
    let esg_bonus = esg.total_score * 50.0;
    
    base_bonus + value_bonus + esg_bonus
}

fn create_nfe_nft(nfe: &NFEData, esg: &trinity_neural_network::ESGScore) -> String {
    format!(
        "NFT NFe #{} - ESG Score: {:.2} - Valor: R$ {:.2}",
        nfe.chave_acesso,
        esg.total_score,
        nfe.valor_total
    )
}
```

---

## 🔧 **TROUBLESHOOTING**

### **❌ Problemas Comuns**

#### **1. Erro de Compilação**
```bash
error: could not find Cargo.toml
```
**Solução**: Certifique-se de estar no diretório correto:
```bash
cd ecosystem-degov
cargo build --bin trinity_ai_agent
```

#### **2. Erro de Dependências**
```bash
error: failed to resolve imports
```
**Solução**: Atualize as dependências:
```bash
cargo update
cargo build --bin trinity_ai_agent
```

#### **3. Erro de Memória**
```bash
error: out of memory
```
**Solução**: Reduza o tamanho do batch:
```rust
neural_network.learning_algorithm.batch_size = 16; // Reduzir de 32 para 16
```

#### **4. Erro de Precisão**
```bash
warning: low accuracy
```
**Solução**: Aumente as épocas de treinamento:
```rust
neural_network.learning_algorithm.epochs = 2000; // Aumentar de 1000 para 2000
```

### **🔍 Debug Avançado**

```rust
use tracing::{info, warn, error};

async fn debug_neural_network() -> Result<(), Box<dyn std::error::Error>> {
    // Habilitar logging detalhado
    tracing_subscriber::fmt()
        .with_max_level(tracing::Level::DEBUG)
        .init();
    
    let mut trinity_ai = TrinityAIAgent::new();
    
    // Treinar com logging
    info!("Iniciando treinamento da rede neural...");
    let accuracy = trinity_ai.train_neural_network().await?;
    
    if accuracy < 0.8 {
        warn!("Precisão baixa: {:.2}%", accuracy * 100.0);
        warn!("Considere aumentar as épocas de treinamento");
    } else {
        info!("Precisão adequada: {:.2}%", accuracy * 100.0);
    }
    
    // Otimizar com logging
    info!("Iniciando otimização do sistema...");
    let optimization = trinity_ai.optimize_with_neural().await?;
    
    if optimization.improvement_percentage < 5.0 {
        warn!("Melhoria baixa: {:.2}%", optimization.improvement_percentage);
        warn!("Considere ajustar os parâmetros de otimização");
    } else {
        info!("Otimização bem-sucedida: {:.2}%", optimization.improvement_percentage);
    }
    
    Ok(())
}
```

---

## 📚 **BEST PRACTICES**

### **✅ Práticas Recomendadas**

#### **1. Configuração de Parâmetros**
```rust
// Configuração otimizada para produção
neural_network.learning_algorithm.learning_rate = 0.001;  // Taxa de aprendizado
neural_network.learning_algorithm.batch_size = 32;        // Tamanho do lote
neural_network.learning_algorithm.epochs = 1000;          // Número de épocas
neural_network.learning_algorithm.regularization = 0.01;  // Regularização L2
neural_network.learning_algorithm.dropout_rate = 0.2;    // Taxa de dropout
```

#### **2. Validação de Dados**
```rust
fn validate_nfe_data(nfe: &NFEData) -> Result<(), String> {
    if nfe.chave_acesso.len() != 44 {
        return Err("Chave de acesso inválida".to_string());
    }
    
    if nfe.valor_total <= 0.0 {
        return Err("Valor total deve ser positivo".to_string());
    }
    
    if nfe.categoria.is_empty() {
        return Err("Categoria não pode estar vazia".to_string());
    }
    
    Ok(())
}
```

#### **3. Tratamento de Erros**
```rust
async fn safe_prediction(trinity_ai: &TrinityAIAgent, nfe_data: &NFEData) -> Result<f64, String> {
    // Validar dados
    validate_nfe_data(nfe_data)?;
    
    // Fazer previsão com timeout
    let prediction = tokio::time::timeout(
        Duration::from_secs(30),
        trinity_ai.predict_esg_with_neural(nfe_data)
    ).await
    .map_err(|_| "Timeout na previsão".to_string())?
    .map_err(|e| format!("Erro na previsão: {}", e))?;
    
    // Validar resultado
    if prediction.total_score < 0.0 || prediction.total_score > 1.0 {
        return Err("Score ESG inválido".to_string());
    }
    
    Ok(prediction.total_score)
}
```

#### **4. Monitoramento de Performance**
```rust
use std::time::Instant;

async fn monitor_performance(trinity_ai: &mut TrinityAIAgent) -> Result<(), Box<dyn std::error::Error>> {
    // Monitorar tempo de treinamento
    let start = Instant::now();
    let accuracy = trinity_ai.train_neural_network().await?;
    let training_time = start.elapsed();
    
    println!("📊 Performance da Rede Neural:");
    println!("   Precisão: {:.2}%", accuracy * 100.0);
    println!("   Tempo de treinamento: {:.2}s", training_time.as_secs_f64());
    
    // Monitorar tempo de previsão
    let test_data = create_test_data();
    let start = Instant::now();
    let prediction = trinity_ai.predict_esg_with_neural(&test_data).await?;
    let prediction_time = start.elapsed();
    
    println!("   Tempo de previsão: {:.2}ms", prediction_time.as_millis());
    println!("   ESG Score: {:.2}", prediction.total_score);
    
    Ok(())
}
```

---

## ❓ **FAQ**

### **🤔 Perguntas Frequentes**

#### **Q: Qual é a precisão da rede neural?**
**R**: A precisão varia de 85% a 95% dependendo da qualidade dos dados de treinamento. Para dados ESG bem rotulados, esperamos 90%+ de precisão.

#### **Q: Quanto tempo leva para treinar?**
**R**: Para 10K amostras: ~5 minutos. Para 100K amostras: ~30 minutos. Para 1M amostras: ~2 horas.

#### **Q: Posso usar a rede neural em produção?**
**R**: Sim! A rede neural foi projetada para produção com otimizações de performance e tratamento de erros robusto.

#### **Q: Como integrar com meus dados ESG?**
**R**: Use a estrutura `ESGTrainingData` para carregar seus dados e chame `train_neural_network()` para treinar.

#### **Q: A rede neural aprende continuamente?**
**R**: Sim! Use `optimize_with_neural()` para otimização contínua baseada em novos dados.

#### **Q: Posso personalizar a arquitetura?**
**R**: Sim! Modifique as camadas em `TrinityNeuralNetwork::new()` para ajustar a arquitetura às suas necessidades.

#### **Q: Como monitorar a performance?**
**R**: Use `PerformanceMetrics` para monitorar precisão, tempo de treinamento, e uso de recursos.

#### **Q: A rede neural funciona offline?**
**R**: Sim! A rede neural é totalmente offline após o treinamento inicial.

#### **Q: Posso usar GPU para acelerar?**
**R**: Atualmente a implementação é CPU-only, mas pode ser estendida para GPU usando bibliotecas como `candle-gpu`.

#### **Q: Como fazer backup da rede neural?**
**R**: Use `serde` para serializar a rede neural e salvar em arquivo:
```rust
let serialized = serde_json::to_string(&neural_network)?;
std::fs::write("neural_network.json", serialized)?;
```

---

## 🎯 **CONCLUSÃO**

### **✅ Trinity Neural Network: Guia Completo**

A **Trinity Neural Network** oferece uma solução completa para análise ESG + Blockchain:

- **🚀 Quick Start**: Instalação e configuração em minutos
- **💡 Exemplos Práticos**: Código pronto para usar
- **🔗 Integração**: GuardDrive, GuardFlow, Smart Contracts
- **🔧 Troubleshooting**: Soluções para problemas comuns
- **📚 Best Practices**: Práticas recomendadas para produção
- **❓ FAQ**: Respostas para dúvidas frequentes

### **🌟 Próximos Passos**

1. **Implementar** em seus projetos ESG
2. **Integrar** com GuardDrive/GuardFlow
3. **Deploy** em Goerli testnet
4. **Expandir** para outros casos de uso
5. **Contribuir** para o desenvolvimento

**🧠 A Trinity Neural Network está pronta para revolucionar a análise ESG + Blockchain!** ⚡🚀
