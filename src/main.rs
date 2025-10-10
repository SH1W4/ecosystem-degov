use axum::{
    extract::Path,
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use tokio::net::TcpListener;

mod gst;
use gst::*;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HealthResponse {
    pub status: String,
    pub service: String,
    pub version: String,
    pub timestamp: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ESGMetrics {
    pub id: String,
    pub entity_id: String,
    pub score: f64,
    pub timestamp: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateMetricsRequest {
    pub entity_id: String,
    pub score: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIRequest {
    pub text: Option<String>,
    pub image_data: Option<String>,
    pub analysis_type: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIResponse {
    pub result: String,
    pub confidence: f64,
    pub processing_time: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockchainRequest {
    pub metrics_id: String,
    pub amount: f64,
    pub blockchain: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockchainResponse {
    pub transaction_hash: String,
    pub token_id: String,
    pub amount: f64,
    pub blockchain: String,
}

// Health check endpoint
async fn health_check() -> Json<HealthResponse> {
    Json(HealthResponse {
        status: "ok".to_string(),
        service: "ESG Token Ecosystem Rust Backend".to_string(),
        version: "1.0.0".to_string(),
        timestamp: chrono::Utc::now().to_rfc3339(),
    })
}

// ESG Metrics endpoints
async fn create_metrics(
    Json(payload): Json<CreateMetricsRequest>,
) -> Result<Json<ESGMetrics>, StatusCode> {
    let metrics = ESGMetrics {
        id: uuid::Uuid::new_v4().to_string(),
        entity_id: payload.entity_id,
        score: payload.score,
        timestamp: chrono::Utc::now().to_rfc3339(),
    };
    
    Ok(Json(metrics))
}

async fn get_metrics(Path(id): Path<String>) -> Result<Json<ESGMetrics>, StatusCode> {
    // Mock response for now
    let metrics = ESGMetrics {
        id,
        entity_id: "mock-entity".to_string(),
        score: 0.85,
        timestamp: chrono::Utc::now().to_rfc3339(),
    };
    
    Ok(Json(metrics))
}

// AI Services endpoints
async fn analyze_text(Json(payload): Json<AIRequest>) -> Result<Json<AIResponse>, StatusCode> {
    let result = match payload.analysis_type.as_str() {
        "sentiment" => {
            if let Some(text) = payload.text {
                if text.contains("good") || text.contains("positive") {
                    "positive"
                } else if text.contains("bad") || text.contains("negative") {
                    "negative"
                } else {
                    "neutral"
                }
            } else {
                "neutral"
            }
        },
        "classification" => "sustainability",
        "entity_extraction" => "GuardFlow, ESG, Sustainability",
        _ => "unknown",
    };

    Ok(Json(AIResponse {
        result: result.to_string(),
        confidence: 0.85,
        processing_time: 0.1,
    }))
}

async fn analyze_image(Json(_payload): Json<AIRequest>) -> Result<Json<AIResponse>, StatusCode> {
    Ok(Json(AIResponse {
        result: "sustainable product detected".to_string(),
        confidence: 0.92,
        processing_time: 0.5,
    }))
}

async fn generate_predictions(Json(_payload): Json<AIRequest>) -> Result<Json<AIResponse>, StatusCode> {
    Ok(Json(AIResponse {
        result: "carbon emissions will decrease by 15% in next quarter".to_string(),
        confidence: 0.88,
        processing_time: 0.3,
    }))
}

async fn generate_recommendations(Json(_payload): Json<AIRequest>) -> Result<Json<AIResponse>, StatusCode> {
    Ok(Json(AIResponse {
        result: "implement renewable energy sources, optimize supply chain".to_string(),
        confidence: 0.90,
        processing_time: 0.2,
    }))
}

// Blockchain endpoints
async fn tokenize_metrics(Json(payload): Json<BlockchainRequest>) -> Result<Json<BlockchainResponse>, StatusCode> {
    Ok(Json(BlockchainResponse {
        transaction_hash: format!("0x{}", uuid::Uuid::new_v4().to_string().replace("-", "")),
        token_id: format!("ESG_TOKEN_{}", payload.metrics_id),
        amount: payload.amount,
        blockchain: payload.blockchain,
    }))
}

async fn get_token_balance(Path(token_id): Path<String>) -> Result<Json<HashMap<String, f64>>, StatusCode> {
    let mut balance = HashMap::new();
    balance.insert("balance".to_string(), 100.0);
    balance.insert("token_id".to_string(), token_id.parse().unwrap_or(0.0));
    
    Ok(Json(balance))
}

async fn transfer_tokens(Json(_payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let mut response = HashMap::new();
    response.insert("transaction_hash".to_string(), format!("0x{}", uuid::Uuid::new_v4().to_string().replace("-", "")));
    response.insert("status".to_string(), "success".to_string());
    
    Ok(Json(response))
}

// Analytics endpoints
async fn get_analytics() -> Result<Json<HashMap<String, f64>>, StatusCode> {
    let mut analytics = HashMap::new();
    analytics.insert("total_metrics".to_string(), 1250.0);
    analytics.insert("average_score".to_string(), 0.82);
    analytics.insert("carbon_reduction".to_string(), 0.15);
    analytics.insert("energy_efficiency".to_string(), 0.78);
    
    Ok(Json(analytics))
}

async fn get_trends() -> Result<Json<HashMap<String, Vec<f64>>>, StatusCode> {
    let mut trends = HashMap::new();
    trends.insert("carbon_emissions".to_string(), vec![100.0, 95.0, 90.0, 85.0, 80.0]);
    trends.insert("energy_consumption".to_string(), vec![1000.0, 950.0, 900.0, 850.0, 800.0]);
    trends.insert("esg_score".to_string(), vec![0.7, 0.75, 0.8, 0.82, 0.85]);
    
    Ok(Json(trends))
}

// GST Token endpoints
async fn get_gst_token_info(Path(token_id): Path<String>) -> Result<Json<GSTToken>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let token = gst_service.get_token_info(&token_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(token))
}

async fn get_gst_balance(Path((address, token_id)): Path<(String, String)>) -> Result<Json<GSTBalance>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let balance = gst_service.get_balance(&address, &token_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(balance))
}

async fn transfer_gst_tokens(Json(payload): Json<HashMap<String, String>>) -> Result<Json<GSTTransaction>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let from = payload.get("from").unwrap_or(&"0x0".to_string()).clone();
    let to = payload.get("to").unwrap_or(&"0x0".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let token_id = payload.get("token_id").unwrap_or(&"GST".to_string()).clone();
    
    let transaction = gst_service.transfer_tokens(&from, &to, amount, &token_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(transaction))
}

// GST Marketplace endpoints
async fn list_marketplace_item(Json(payload): Json<HashMap<String, String>>) -> Result<Json<GSTMarketplaceItem>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let seller = payload.get("seller").unwrap_or(&"0x0".to_string()).clone();
    let token_id = payload.get("token_id").unwrap_or(&"GST".to_string()).clone();
    let price = payload.get("price").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let quantity = payload.get("quantity").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let description = payload.get("description").unwrap_or(&"".to_string()).clone();
    let category = payload.get("category").unwrap_or(&"general".to_string()).clone();
    
    let item = gst_service.list_item(&seller, &token_id, price, quantity, &description, &category).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(item))
}

async fn buy_marketplace_item(Json(payload): Json<HashMap<String, String>>) -> Result<Json<GSTTransaction>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let buyer = payload.get("buyer").unwrap_or(&"0x0".to_string()).clone();
    let item_id = payload.get("item_id").unwrap_or(&"".to_string()).clone();
    let quantity = payload.get("quantity").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    
    let transaction = gst_service.buy_item(&buyer, &item_id, quantity).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(transaction))
}

// GST Gamification endpoints
async fn get_user_gamification(Path(user_id): Path<String>) -> Result<Json<GSTGamification>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let gamification = gst_service.get_user_gamification(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(gamification))
}

async fn complete_mission(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let mission_id = payload.get("mission_id").unwrap_or(&"".to_string()).clone();
    
    let rewards = gst_service.complete_mission(&user_id, &mission_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("rewards".to_string(), rewards);
    Ok(Json(response))
}

// GST Governance endpoints
async fn create_governance_proposal(Json(payload): Json<HashMap<String, String>>) -> Result<Json<GSTGovernanceProposal>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let proposer = payload.get("proposer").unwrap_or(&"0x0".to_string()).clone();
    let title = payload.get("title").unwrap_or(&"".to_string()).clone();
    let description = payload.get("description").unwrap_or(&"".to_string()).clone();
    
    let proposal = gst_service.create_proposal(&proposer, &title, &description).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(proposal))
}

async fn vote_on_proposal(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let voter = payload.get("voter").unwrap_or(&"0x0".to_string()).clone();
    let proposal_id = payload.get("proposal_id").unwrap_or(&"".to_string()).clone();
    let vote = payload.get("vote").unwrap_or(&"false".to_string()).parse::<bool>().unwrap_or(false);
    
    gst_service.vote_on_proposal(&voter, &proposal_id, vote).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("status".to_string(), "success".to_string());
    Ok(Json(response))
}

// NFE to NFT endpoints
async fn convert_nfe_to_nft(Json(payload): Json<HashMap<String, String>>) -> Result<Json<NFEToNFT>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let nfe_id = payload.get("nfe_id").unwrap_or(&"".to_string()).clone();
    let owner = payload.get("owner").unwrap_or(&"0x0".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
    let sustainability_score = payload.get("sustainability_score").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
    
    let nft = gst_service.convert_nfe_to_nft(&nfe_id, &owner, amount, sustainability_score).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(nft))
}

// Smart Cart endpoints
async fn process_smart_cart(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let gst_service = GSTService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let cart_id = payload.get("cart_id").unwrap_or(&"".to_string()).clone();
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let sustainability_bonus = payload.get("sustainability_bonus").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
    
    let cart_data = SmartCartData {
        cart_id,
        user_id,
        items: vec![],
        total_amount: 0.0,
        sustainability_bonus,
        gst_rewards: 0,
        nfe_generated: false,
        nft_created: false,
    };
    
    let (gst_rewards, nft_created) = gst_service.process_smart_cart(cart_data).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    let mut response = HashMap::new();
    response.insert("gst_rewards".to_string(), gst_rewards.to_string());
    response.insert("nft_created".to_string(), nft_created.to_string());
    Ok(Json(response))
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize logging
    env_logger::init();

    // Create the router
    let app = Router::new()
        // Health check
        .route("/health", get(health_check))
        
        // ESG Metrics
        .route("/api/v1/metrics", post(create_metrics))
        .route("/api/v1/metrics/:id", get(get_metrics))
        
        // AI Services
        .route("/api/v1/ai/analyze", post(analyze_text))
        .route("/api/v1/ai/vision", post(analyze_image))
        .route("/api/v1/ai/predictions", post(generate_predictions))
        .route("/api/v1/ai/recommendations", post(generate_recommendations))
        
        // Blockchain
        .route("/api/v1/tokenize", post(tokenize_metrics))
        .route("/api/v1/tokens/:token_id/balance", get(get_token_balance))
        .route("/api/v1/tokens/transfer", post(transfer_tokens))
        
        // Analytics
        .route("/api/v1/analytics", get(get_analytics))
        .route("/api/v1/analytics/trends", get(get_trends))
        
        // GST Token Management
        .route("/api/v1/gst/tokens/:token_id", get(get_gst_token_info))
        .route("/api/v1/gst/balance/:address/:token_id", get(get_gst_balance))
        .route("/api/v1/gst/transfer", post(transfer_gst_tokens))
        
        // GST Marketplace
        .route("/api/v1/gst/marketplace/list", post(list_marketplace_item))
        .route("/api/v1/gst/marketplace/buy", post(buy_marketplace_item))
        
        // GST Gamification
        .route("/api/v1/gst/gamification/:user_id", get(get_user_gamification))
        .route("/api/v1/gst/gamification/complete-mission", post(complete_mission))
        
        // GST Governance
        .route("/api/v1/gst/governance/propose", post(create_governance_proposal))
        .route("/api/v1/gst/governance/vote", post(vote_on_proposal))
        
        // NFE to NFT Conversion
        .route("/api/v1/gst/nfe/convert", post(convert_nfe_to_nft))
        
        // Smart Cart Integration
        .route("/api/v1/gst/smart-cart/process", post(process_smart_cart));

    // Start the server
    let listener = TcpListener::bind("127.0.0.1:3000").await?;
    println!("🚀 ESG Token Ecosystem Rust Backend running on http://127.0.0.1:3000");
    println!("📊 Health check: http://127.0.0.1:3000/health");
    println!("📚 API Documentation: http://127.0.0.1:3000/docs");
    
    axum::serve(listener, app).await?;
    
    Ok(())
}