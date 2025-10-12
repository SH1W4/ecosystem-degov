// SPDX-License-Identifier: MIT
use std::env;
use tokio::time::{sleep, Duration};
use trinity_ai_agent::TrinityAIAgent;
use trinity_mcp_server::TrinityMCPServer;

mod trinity_ai_agent;
mod trinity_mcp_server;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Inicializar logging
    env_logger::init();
    
    println!("🤖 Iniciando Trinity AI Agent + MCP Server...");
    
    // Carregar variáveis de ambiente
    dotenv::dotenv().ok();
    
    // Inicializar Trinity AI Agent
    let mut ai_agent = TrinityAIAgent::new();
    ai_agent.initialize().await?;
    
    // Inicializar MCP Server
    let mut mcp_server = TrinityMCPServer::new();
    mcp_server.initialize().await?;
    
    // Obter porta do MCP Server (padrão: 8080)
    let mcp_port = env::var("MCP_PORT")
        .unwrap_or_else(|_| "8080".to_string())
        .parse::<u16>()
        .unwrap_or(8080);
    
    println!("🚀 Trinity AI Agent + MCP Server iniciados!");
    println!("📡 MCP Server rodando na porta: {}", mcp_port);
    println!("🔗 Conexões disponíveis:");
    println!("   - LLM Integration: OpenAI, Anthropic, Claude");
    println!("   - IDE Integration: VSCode, Cursor, IntelliJ");
    println!("   - Blockchain Integration: Ethereum, Polygon, Celo, XRPL");
    println!("   - Database Integration: PostgreSQL, MongoDB");
    
    // Executar AI Agent em background
    let ai_agent_handle = tokio::spawn(async move {
        if let Err(e) = ai_agent.run().await {
            eprintln!("❌ Erro no Trinity AI Agent: {}", e);
        }
    });
    
    // Executar MCP Server em background
    let mcp_server_handle = tokio::spawn(async move {
        if let Err(e) = mcp_server.start_server(mcp_port).await {
            eprintln!("❌ Erro no MCP Server: {}", e);
        }
    });
    
    // Aguardar ambos os serviços
    tokio::select! {
        _ = ai_agent_handle => {
            println!("🔄 Trinity AI Agent reiniciando...");
        }
        _ = mcp_server_handle => {
            println!("🔄 MCP Server reiniciando...");
        }
    }
    
    Ok(())
}
