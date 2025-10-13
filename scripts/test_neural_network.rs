// SPDX-License-Identifier: MIT
// Teste da Trinity Neural Network com dados reais

use trinity_ai_agent::TrinityAIAgent;
use trinity_neural_network::{NFEData, ESGScore};
use chrono::Utc;
use std::time::Instant;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("🧠 Testando Trinity Neural Network em produção...");
    
    // Criar agente Trinity
    let mut trinity_ai = TrinityAIAgent::new();
    
    // Teste 1: Treinamento da rede neural
    println!("\n📊 Teste 1: Treinamento da rede neural...");
    let start = Instant::now();
    let accuracy = trinity_ai.train_neural_network().await?;
    let training_time = start.elapsed();
    
    println!("✅ Treinamento concluído!");
    println!("   Precisão: {:.2}%", accuracy * 100.0);
    println!("   Tempo: {:.2}s", training_time.as_secs_f64());
    
    // Teste 2: Previsões ESG com dados reais
    println!("\n🔮 Teste 2: Previsões ESG com dados reais...");
    let test_cases = create_test_cases();
    
    for (i, nfe_data) in test_cases.iter().enumerate() {
        println!("\n   Caso {}: {}", i + 1, nfe_data.categoria);
        
        let start = Instant::now();
        let prediction = trinity_ai.predict_esg_with_neural(nfe_data).await?;
        let prediction_time = start.elapsed();
        
        println!("     📊 ESG Score: {:.2}", prediction.total_score);
        println!("     🌱 Ambiental: {:.2}", prediction.environmental);
        println!("     👥 Social: {:.2}", prediction.social);
        println!("     🏛️ Governança: {:.2}", prediction.governance);
        println!("     🎯 Confiança: {:.1}%", prediction.confidence * 100.0);
        println!("     ⚡ Tempo: {:.2}ms", prediction_time.as_millis());
        
        // Interpretar resultado
        interpret_esg_score(&prediction);
    }
    
    // Teste 3: Otimização do sistema
    println!("\n⚡ Teste 3: Otimização do sistema...");
    let start = Instant::now();
    let optimization = trinity_ai.optimize_with_neural().await?;
    let optimization_time = start.elapsed();
    
    println!("✅ Otimização concluída!");
    println!("   Melhoria: {:.2}%", optimization.improvement_percentage);
    println!("   Otimizações aplicadas: {}", optimization.optimizations_applied);
    println!("   Nova performance: {:.2}", optimization.new_performance);
    println!("   Tempo: {:.2}s", optimization_time.as_secs_f64());
    
    // Teste 4: Performance em lote
    println!("\n📈 Teste 4: Performance em lote...");
    let batch_data = create_batch_data(100);
    let start = Instant::now();
    
    let mut batch_predictions = Vec::new();
    for nfe_data in &batch_data {
        let prediction = trinity_ai.predict_esg_with_neural(nfe_data).await?;
        batch_predictions.push(prediction);
    }
    
    let batch_time = start.elapsed();
    let throughput = batch_data.len() as f64 / batch_time.as_secs_f64();
    
    println!("✅ Processamento em lote concluído!");
    println!("   Amostras processadas: {}", batch_data.len());
    println!("   Tempo total: {:.2}s", batch_time.as_secs_f64());
    println!("   Throughput: {:.1} previsões/segundo", throughput);
    
    // Estatísticas finais
    let avg_score: f64 = batch_predictions.iter()
        .map(|p| p.total_score)
        .sum::<f64>() / batch_predictions.len() as f64;
    
    let high_esg_count = batch_predictions.iter()
        .filter(|p| p.total_score >= 0.7)
        .count();
    
    println!("\n📊 Estatísticas Finais:");
    println!("   Score ESG médio: {:.2}", avg_score);
    println!("   Alto ESG (≥70%): {} amostras", high_esg_count);
    println!("   Percentual alto ESG: {:.1}%", 
             (high_esg_count as f64 / batch_predictions.len() as f64) * 100.0);
    
    println!("\n🎉 Teste da Trinity Neural Network concluído com sucesso!");
    
    Ok(())
}

fn create_test_cases() -> Vec<NFEData> {
    vec![
        // Caso 1: Energia Renovável
        NFEData {
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
        },
        // Caso 2: Reciclagem
        NFEData {
            chave_acesso: "35240114200166000187550010000000271123456790".to_string(),
            valor_total: 800.0,
            categoria: "Reciclagem".to_string(),
            municipio: "Rio de Janeiro".to_string(),
            uf: "RJ".to_string(),
            cnpj_emitente: "14200166000187".to_string(),
            cnpj_destinatario: "12345678000195".to_string(),
            data_emissao: Utc::now(),
            esg_score: 0.0,
            is_verificada: true,
        },
        // Caso 3: Sustentável
        NFEData {
            chave_acesso: "35240114200166000187550010000000271123456791".to_string(),
            valor_total: 1500.0,
            categoria: "Sustentavel".to_string(),
            municipio: "Belo Horizonte".to_string(),
            uf: "MG".to_string(),
            cnpj_emitente: "14200166000187".to_string(),
            cnpj_destinatario: "12345678000195".to_string(),
            data_emissao: Utc::now(),
            esg_score: 0.0,
            is_verificada: true,
        },
        // Caso 4: Veículo Elétrico
        NFEData {
            chave_acesso: "35240114200166000187550010000000271123456792".to_string(),
            valor_total: 120.0,
            categoria: "Eletrico".to_string(),
            municipio: "Porto Alegre".to_string(),
            uf: "RS".to_string(),
            cnpj_emitente: "14200166000187".to_string(),
            cnpj_destinatario: "12345678000195".to_string(),
            data_emissao: Utc::now(),
            esg_score: 0.0,
            is_verificada: true,
        },
        // Caso 5: Híbrido
        NFEData {
            chave_acesso: "35240114200166000187550010000000271123456793".to_string(),
            valor_total: 2000.0,
            categoria: "Hibrido".to_string(),
            municipio: "Brasília".to_string(),
            uf: "DF".to_string(),
            cnpj_emitente: "14200166000187".to_string(),
            cnpj_destinatario: "12345678000195".to_string(),
            data_emissao: Utc::now(),
            esg_score: 0.0,
            is_verificada: true,
        },
    ]
}

fn create_batch_data(size: usize) -> Vec<NFEData> {
    let categories = vec![
        "Energia Renovavel",
        "Reciclagem", 
        "Sustentavel",
        "Eletrico",
        "Hibrido"
    ];
    
    let cities = vec![
        ("São Paulo", "SP"),
        ("Rio de Janeiro", "RJ"),
        ("Belo Horizonte", "MG"),
        ("Porto Alegre", "RS"),
        ("Brasília", "DF"),
    ];
    
    (0..size).map(|i| {
        let category = categories[i % categories.len()];
        let (municipio, uf) = cities[i % cities.len()];
        
        NFEData {
            chave_acesso: format!("3524011420016600018755001000000027112345{:04}", i),
            valor_total: 500.0 + (i as f64 * 100.0),
            categoria: category.to_string(),
            municipio: municipio.to_string(),
            uf: uf.to_string(),
            cnpj_emitente: "14200166000187".to_string(),
            cnpj_destinatario: "12345678000195".to_string(),
            data_emissao: Utc::now(),
            esg_score: 0.0,
            is_verificada: true,
        }
    }).collect()
}

fn interpret_esg_score(score: &ESGScore) {
    let total = score.total_score;
    
    match total {
        t if t >= 0.9 => println!("     🌟 Excelente! Alto impacto ESG positivo"),
        t if t >= 0.7 => println!("     ✅ Bom! Impacto ESG positivo"),
        t if t >= 0.5 => println!("     ⚠️ Regular. Impacto ESG neutro"),
        t if t >= 0.3 => println!("     ❌ Ruim. Impacto ESG negativo"),
        _ => println!("     🚨 Crítico! Alto impacto ESG negativo"),
    }
}
