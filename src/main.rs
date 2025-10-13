// SPDX-License-Identifier: MIT
//! Trinity AI Agent - Autonomous AI Agent for ESG Token Ecosystem Management
//! 
//! This is a standalone, production-ready AI agent designed to autonomously
//! manage and optimize ESG token ecosystems. Built with Rust for maximum
//! performance, safety, and reliability.

use std::env;
use trinity_ai_agent::TrinityAIAgent;
use trinity_mcp_server::TrinityMCPServer;

mod trinity_ai_agent;
mod trinity_mcp_server;
mod trinity_neural_network;
mod trinity_system_consciousness; // Consciência Sistêmica

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize logging
    env_logger::init();
    
    println!("🤖 Trinity AI Agent v1.0.0");
    println!("🚀 Autonomous ESG Token Ecosystem Manager");
    println!("⚡ Built with Rust for maximum performance");
    println!("🔗 MCP Integration: LLMs, IDEs, Blockchains");
    println!();
    
    // Load environment variables
    dotenv::dotenv().ok();
    
    // Initialize Trinity AI Agent
    println!("🤖 Initializing Trinity AI Agent...");
    let mut ai_agent = TrinityAIAgent::new();
    ai_agent.initialize().await?;
    println!("✅ Trinity AI Agent initialized successfully!");
    
    // Initialize MCP Server
    println!("🌐 Initializing Trinity MCP Server...");
    let mut mcp_server = TrinityMCPServer::new();
    mcp_server.initialize().await?;
    
    // Get MCP Server port (default: 8080)
    let mcp_port = env::var("MCP_PORT")
        .unwrap_or_else(|_| "8080".to_string())
        .parse::<u16>()
        .unwrap_or(8080);
    
    println!("🚀 Trinity AI Agent + MCP Server started!");
    println!("📡 MCP Server running on port: {}", mcp_port);
    println!("🔗 Available connections:");
    println!("   - LLM Integration: OpenAI, Anthropic, Claude");
    println!("   - IDE Integration: VSCode, Cursor, IntelliJ");
    println!("   - Blockchain Integration: Ethereum, Polygon, Celo, XRPL");
    println!("   - Database Integration: PostgreSQL, MongoDB");
    println!();
    println!("⚡ Trinity AI Agent is now autonomously managing your ecosystem!");
    println!("🧠 Learning, optimizing, and evolving continuously...");
    println!();
    
    // Run AI Agent in background
    let ai_agent_handle = tokio::spawn(async move {
        if let Err(e) = ai_agent.run().await {
            eprintln!("❌ Error in Trinity AI Agent: {}", e);
        }
    });
    
    // Run MCP Server in background
    let mcp_server_handle = tokio::spawn(async move {
        if let Err(e) = mcp_server.start_server(mcp_port).await {
            eprintln!("❌ Error in MCP Server: {}", e);
        }
    });
    
    // Wait for both services
    tokio::select! {
        _ = ai_agent_handle => {
            println!("🔄 Trinity AI Agent restarting...");
        }
        _ = mcp_server_handle => {
            println!("🔄 MCP Server restarting...");
        }
    }
    
    Ok(())
}