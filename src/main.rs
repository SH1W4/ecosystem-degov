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
mod mobility;
mod ecotoken;
use gst::*;
use mobility::*;
use mobility::cross_platform::{CrossPlatformBalance, CrossPlatformService};
use mobility::integration::{ESGIntegrationService, UnifiedESGProfile};
use ecotoken::*;

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

    // GuardDrive Integration endpoints
    async fn sync_mobility_telemetry(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
        let mobility_service = MobilityService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        let vehicle_id = payload.get("vehicle_id").unwrap_or(&"".to_string()).clone();
        let driving_efficiency = payload.get("driving_efficiency").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
        let carbon_footprint = payload.get("carbon_footprint").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
        let sustainability_score = payload.get("sustainability_score").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
        
        let telemetry = MobilityTelemetry {
            vehicle_id,
            timestamp: chrono::Utc::now().to_rfc3339(),
            driving_efficiency,
            carbon_footprint,
            fuel_consumption: 0.0,
            distance_traveled: 0.0,
            sustainability_score,
            eco_driving_score: 0.0,
        };
        
        let tokens = mobility_service.sync_telemetry(telemetry).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        
        let mut response = HashMap::new();
        response.insert("esg_tokens".to_string(), tokens);
        Ok(Json(response))
    }

    async fn get_mobility_vehicle(Path(vehicle_id): Path<String>) -> Result<Json<MobilityVehicle>, StatusCode> {
        let mobility_service = MobilityService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        let vehicle = mobility_service.get_vehicle_info(&vehicle_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        Ok(Json(vehicle))
    }

    // Cross-Platform Integration endpoints
    async fn get_cross_platform_balance(Path(user_id): Path<String>) -> Result<Json<CrossPlatformBalance>, StatusCode> {
        let cross_platform_service = CrossPlatformService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        let balance = cross_platform_service.get_unified_balance(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        Ok(Json(balance))
    }

    async fn transfer_cross_platform_tokens(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
        let cross_platform_service = CrossPlatformService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        let from_platform = payload.get("from_platform").unwrap_or(&"".to_string()).clone();
        let to_platform = payload.get("to_platform").unwrap_or(&"".to_string()).clone();
        let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
        
        let final_amount = cross_platform_service.transfer_tokens(&from_platform, &to_platform, amount).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
        
        let mut response = HashMap::new();
        response.insert("final_amount".to_string(), final_amount);
        Ok(Json(response))
    }

// Removed duplicate function - using the one in ESG Integration Handlers section

// EcoToken (ECT) endpoints
async fn get_ecotoken_info() -> Result<Json<EcoToken>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let info = ecotoken_service.get_ecotoken_info().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(info))
}

async fn get_ecotoken_balance(Path(address): Path<String>) -> Result<Json<EcoTokenBalance>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let balance = ecotoken_service.get_ecotoken_balance(&address).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(balance))
}

async fn transfer_ecotoken(Json(payload): Json<HashMap<String, String>>) -> Result<Json<EcoTokenTransaction>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let from = payload.get("from").unwrap_or(&"0x0".to_string()).clone();
    let to = payload.get("to").unwrap_or(&"0x0".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    
    let transaction = ecotoken_service.transfer(&from, &to, amount).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(transaction))
}

async fn start_ecotoken_staking(Json(payload): Json<HashMap<String, String>>) -> Result<Json<EcoTokenStaking>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user = payload.get("user").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let duration = payload.get("duration").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    
    let staking = ecotoken_service.start_staking(&user, amount, duration).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(staking))
}

async fn end_ecotoken_staking(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user = payload.get("user").unwrap_or(&"".to_string()).clone();
    
    let rewards = ecotoken_service.end_staking(&user).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("rewards".to_string(), rewards);
    Ok(Json(response))
}

async fn get_ecotoken_rewards(Path(user_id): Path<String>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let rewards = ecotoken_service.calculate_rewards(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("rewards".to_string(), rewards);
    Ok(Json(response))
}

// EcoScore (ECS) endpoints
async fn get_ecoscore_profile(Path(user_id): Path<String>) -> Result<Json<EcoScore>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let profile = ecotoken_service.get_ecoscore(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(profile))
}

async fn mint_ecoscore(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let reason = payload.get("reason").unwrap_or(&"ESG Reward".to_string()).clone();
    
    let minted = ecotoken_service.mint_ecoscore(&user_id, amount, &reason).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("minted".to_string(), minted);
    Ok(Json(response))
}

async fn get_ecoscore_benefits(Path(user_id): Path<String>) -> Result<Json<Vec<EcoScoreBenefit>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let benefits = ecotoken_service.get_available_benefits(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(benefits))
}

async fn get_ecoscore_levels() -> Result<Json<Vec<EcoScoreLevel>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let levels = ecotoken_service.get_ecoscore_levels().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(levels))
}

async fn add_ecoscore_achievement(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let achievement = payload.get("achievement").unwrap_or(&"".to_string()).clone();
    
    ecotoken_service.add_achievement(&user_id, &achievement).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("status".to_string(), "success".to_string());
    Ok(Json(response))
}

// CarbonCredit (CCR) endpoints
async fn get_carbon_credits(Path(user_id): Path<String>) -> Result<Json<CarbonCredit>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let credits = ecotoken_service.get_carbon_credits(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(credits))
}

async fn mint_carbon_credits(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let verification_id = payload.get("verification_id").unwrap_or(&"".to_string()).clone();
    
    let minted = ecotoken_service.mint_carbon_credits(&user_id, amount, &verification_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("minted".to_string(), minted);
    Ok(Json(response))
}

async fn retire_carbon_credits(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let purpose = payload.get("purpose").unwrap_or(&"Carbon offset".to_string()).clone();
    
    let retirement_id = ecotoken_service.retire_credits(&user_id, amount, &purpose).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("retirement_id".to_string(), retirement_id);
    Ok(Json(response))
}

async fn add_carbon_verification(Json(payload): Json<HashMap<String, String>>) -> Result<Json<CarbonVerification>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let verification_id = payload.get("verification_id").unwrap_or(&"".to_string()).clone();
    let co2_reduced = payload.get("co2_reduced").unwrap_or(&"0.0".to_string()).parse::<f64>().unwrap_or(0.0);
    let methodology = payload.get("methodology").unwrap_or(&"GHG Protocol".to_string()).clone();
    
    let verification = ecotoken_service.add_verification(&verification_id, co2_reduced, &methodology).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(verification))
}

async fn get_carbon_marketplace() -> Result<Json<Vec<CarbonMarketplaceListing>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let listings = ecotoken_service.get_carbon_marketplace().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(listings))
}

async fn buy_carbon_credits(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let buyer = payload.get("buyer").unwrap_or(&"".to_string()).clone();
    let listing_id = payload.get("listing_id").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    
    let purchase = ecotoken_service.buy_carbon_credits(&buyer, &listing_id, amount).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("purchase_id".to_string(), purchase.purchase_id);
    Ok(Json(response))
}

// EcoCertificate (ECR) endpoints
async fn mint_certificate(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let certificate_type = payload.get("certificate_type").unwrap_or(&"Carbon Neutral".to_string()).clone();
    let impact_score = payload.get("impact_score").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let rarity = payload.get("rarity").unwrap_or(&"1".to_string()).parse::<u32>().unwrap_or(1);
    let metadata = payload.get("metadata").unwrap_or(&"".to_string()).clone();
    
    let token_id = ecotoken_service.mint_certificate(&user_id, &certificate_type, impact_score, rarity, &metadata).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("token_id".to_string(), token_id);
    Ok(Json(response))
}

async fn get_user_certificates(Path(user_id): Path<String>) -> Result<Json<Vec<EcoCertificate>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let certificates = ecotoken_service.get_user_certificates(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(certificates))
}

async fn get_certificate_data(Path(token_id): Path<String>) -> Result<Json<EcoCertificate>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let certificate = ecotoken_service.get_certificate_data(&token_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(certificate))
}

async fn verify_certificate(Path(token_id): Path<String>) -> Result<Json<HashMap<String, bool>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let verified = ecotoken_service.verify_certificate(&token_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("verified".to_string(), verified);
    Ok(Json(response))
}

async fn list_certificate(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let token_id = payload.get("token_id").unwrap_or(&"".to_string()).clone();
    let price = payload.get("price").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    
    let listing = ecotoken_service.list_certificate(&user_id, &token_id, price).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("listing_id".to_string(), listing.listing_id);
    Ok(Json(response))
}

async fn buy_certificate(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let buyer = payload.get("buyer").unwrap_or(&"".to_string()).clone();
    let listing_id = payload.get("listing_id").unwrap_or(&"".to_string()).clone();
    
    let purchase = ecotoken_service.buy_certificate(&buyer, &listing_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("purchase_id".to_string(), purchase.purchase_id);
    Ok(Json(response))
}

async fn get_certificate_types() -> Result<Json<Vec<CertificateType>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let types = ecotoken_service.get_available_types().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(types))
}

// EcoStake (EST) endpoints
async fn get_ecostake_position(Path(user_id): Path<String>) -> Result<Json<EcoStake>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let position = ecotoken_service.get_ecostake(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(position))
}

async fn stake_ecostake(Json(payload): Json<HashMap<String, String>>) -> Result<Json<EcoStakeTier>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let tier = payload.get("tier").unwrap_or(&"Gold".to_string()).clone();
    
    let staking_tier = ecotoken_service.stake_tokens(&user_id, amount, &tier).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(staking_tier))
}

async fn unstake_ecostake(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    
    let rewards = ecotoken_service.unstake_tokens(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("rewards".to_string(), rewards);
    Ok(Json(response))
}

async fn claim_ecostake_rewards(Path(user_id): Path<String>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let rewards = ecotoken_service.claim_rewards(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("rewards".to_string(), rewards);
    Ok(Json(response))
}

async fn get_ecostake_tiers() -> Result<Json<Vec<EcoStakeTier>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let tiers = ecotoken_service.get_ecostake_tiers().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(tiers))
}

async fn get_governance_proposals() -> Result<Json<Vec<GovernanceProposal>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let proposals = ecotoken_service.get_governance_proposals().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(proposals))
}


async fn vote_on_governance(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let voter = payload.get("voter").unwrap_or(&"".to_string()).clone();
    let proposal_id = payload.get("proposal_id").unwrap_or(&"".to_string()).clone();
    let support = payload.get("support").unwrap_or(&"false".to_string()).parse::<bool>().unwrap_or(false);
    
    let _vote = ecotoken_service.vote_on_proposal(&voter, &proposal_id, support).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("status".to_string(), "success".to_string());
    Ok(Json(response))
}

// EcoGem (EGM) endpoints
async fn get_ecogem_balance(Path(user_id): Path<String>) -> Result<Json<EcoGem>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let balance = ecotoken_service.get_ecogem(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(balance))
}

async fn mint_ecogem(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    let reason = payload.get("reason").unwrap_or(&"Premium reward".to_string()).clone();
    
    let minted = ecotoken_service.mint_premium_tokens(&user_id, amount, &reason).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("minted".to_string(), minted);
    Ok(Json(response))
}

async fn get_vip_status(Path(user_id): Path<String>) -> Result<Json<VIPStatus>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let status = ecotoken_service.get_vip_status(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(status))
}

async fn get_ecogem_benefits(Path(user_id): Path<String>) -> Result<Json<Vec<PremiumFeature>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let benefits = ecotoken_service.get_ecogem_benefits(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(benefits))
}

async fn get_vip_levels() -> Result<Json<Vec<VIPLevel>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let levels = ecotoken_service.get_vip_levels().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(levels))
}

async fn access_premium_feature(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let user_id = payload.get("user_id").unwrap_or(&"".to_string()).clone();
    let feature = payload.get("feature").unwrap_or(&"".to_string()).clone();
    
    ecotoken_service.access_premium_feature(&user_id, &feature).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("status".to_string(), "success".to_string());
    Ok(Json(response))
}

// EcoToken Ecosystem endpoints
async fn get_unified_ecosystem_balance(Path(user_id): Path<String>) -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let balance = ecotoken_service.get_unified_balance(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(balance))
}

async fn transfer_cross_ecosystem(Json(payload): Json<HashMap<String, String>>) -> Result<Json<HashMap<String, String>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let from_user = payload.get("from_user").unwrap_or(&"".to_string()).clone();
    let to_user = payload.get("to_user").unwrap_or(&"".to_string()).clone();
    let token_type = payload.get("token_type").unwrap_or(&"ECT".to_string()).clone();
    let amount = payload.get("amount").unwrap_or(&"0".to_string()).parse::<u64>().unwrap_or(0);
    
    let transaction_id = ecotoken_service.transfer_cross_token(&from_user, &to_user, &token_type, amount).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let mut response = HashMap::new();
    response.insert("transaction_id".to_string(), transaction_id);
    Ok(Json(response))
}

async fn get_ecosystem_stats() -> Result<Json<HashMap<String, u64>>, StatusCode> {
    let ecotoken_service = EcoTokenService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let stats = ecotoken_service.get_ecosystem_stats().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(stats))
}

// ESG Integration Handlers
async fn get_unified_esg_profile(Path(user_id): Path<String>) -> Result<Json<UnifiedESGProfile>, StatusCode> {
    let service = ESGIntegrationService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let profile = service.get_unified_esg_profile(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(profile))
}

async fn transfer_unified_tokens(
    Json(payload): Json<serde_json::Value>
) -> Result<Json<serde_json::Value>, StatusCode> {
    let service = ESGIntegrationService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    let from_platform = payload["from_platform"].as_str().unwrap_or("guardrive");
    let to_platform = payload["to_platform"].as_str().unwrap_or("guardflow");
    let amount = payload["amount"].as_u64().unwrap_or(100);
    
    let result = service.transfer_unified_tokens(from_platform, to_platform, amount).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    
    Ok(Json(serde_json::json!({
        "success": true,
        "final_amount": result,
        "from_platform": from_platform,
        "to_platform": to_platform,
        "original_amount": amount
    })))
}

async fn get_platform_metrics(Path(user_id): Path<String>) -> Result<Json<HashMap<String, f64>>, StatusCode> {
    let service = ESGIntegrationService::new().await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let metrics = service.get_platform_metrics(&user_id).await.map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    Ok(Json(metrics))
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
            .route("/api/v1/gst/smart-cart/process", post(process_smart_cart))
            
            // GuardDrive Integration
            .route("/api/v1/gst/mobility/sync", post(sync_mobility_telemetry))
            .route("/api/v1/gst/mobility/vehicle/:vehicle_id", get(get_mobility_vehicle))
            
            // Cross-Platform Integration
            .route("/api/v1/gst/cross-platform/balance/:user_id", get(get_cross_platform_balance))
            .route("/api/v1/gst/cross-platform/transfer", post(transfer_cross_platform_tokens))
            .route("/api/v1/gst/cross-platform/profile/:user_id", get(get_unified_esg_profile))
            
            // EcoToken (ECT) endpoints
            .route("/api/v1/ecotoken/info", get(get_ecotoken_info))
            .route("/api/v1/ecotoken/balance/:address", get(get_ecotoken_balance))
            .route("/api/v1/ecotoken/transfer", post(transfer_ecotoken))
            .route("/api/v1/ecotoken/stake", post(start_ecotoken_staking))
            .route("/api/v1/ecotoken/unstake", post(end_ecotoken_staking))
            .route("/api/v1/ecotoken/rewards/:user_id", get(get_ecotoken_rewards))
            
            // EcoScore (ECS) endpoints
            .route("/api/v1/ecoscore/profile/:user_id", get(get_ecoscore_profile))
            .route("/api/v1/ecoscore/mint", post(mint_ecoscore))
            .route("/api/v1/ecoscore/benefits/:user_id", get(get_ecoscore_benefits))
            .route("/api/v1/ecoscore/levels", get(get_ecoscore_levels))
            .route("/api/v1/ecoscore/achievement", post(add_ecoscore_achievement))
            
            // CarbonCredit (CCR) endpoints
            .route("/api/v1/carboncredits/balance/:user_id", get(get_carbon_credits))
            .route("/api/v1/carboncredits/mint", post(mint_carbon_credits))
            .route("/api/v1/carboncredits/retire", post(retire_carbon_credits))
            .route("/api/v1/carboncredits/verify", post(add_carbon_verification))
            .route("/api/v1/carboncredits/marketplace", get(get_carbon_marketplace))
            .route("/api/v1/carboncredits/buy", post(buy_carbon_credits))
            
            // EcoCertificate (ECR) endpoints
            .route("/api/v1/certificates/mint", post(mint_certificate))
            .route("/api/v1/certificates/user/:user_id", get(get_user_certificates))
            .route("/api/v1/certificates/:token_id", get(get_certificate_data))
            .route("/api/v1/certificates/verify/:token_id", post(verify_certificate))
            .route("/api/v1/certificates/list", post(list_certificate))
            .route("/api/v1/certificates/buy", post(buy_certificate))
            .route("/api/v1/certificates/types", get(get_certificate_types))
            
            // EcoStake (EST) endpoints
            .route("/api/v1/ecostake/position/:user_id", get(get_ecostake_position))
            .route("/api/v1/ecostake/stake", post(stake_ecostake))
            .route("/api/v1/ecostake/unstake", post(unstake_ecostake))
            .route("/api/v1/ecostake/claim/:user_id", post(claim_ecostake_rewards))
            .route("/api/v1/ecostake/tiers", get(get_ecostake_tiers))
            .route("/api/v1/ecostake/proposals", get(get_governance_proposals))
            .route("/api/v1/ecostake/propose", post(create_governance_proposal))
            .route("/api/v1/ecostake/vote", post(vote_on_governance))
            
            // EcoGem (EGM) endpoints
            .route("/api/v1/ecogem/balance/:user_id", get(get_ecogem_balance))
            .route("/api/v1/ecogem/mint", post(mint_ecogem))
            .route("/api/v1/ecogem/vip/:user_id", get(get_vip_status))
            .route("/api/v1/ecogem/benefits/:user_id", get(get_ecogem_benefits))
            .route("/api/v1/ecogem/levels", get(get_vip_levels))
            .route("/api/v1/ecogem/access", post(access_premium_feature))
            
            // EcoToken Ecosystem endpoints
            .route("/api/v1/ecosystem/balance/:user_id", get(get_unified_ecosystem_balance))
            .route("/api/v1/ecosystem/transfer", post(transfer_cross_ecosystem))
            .route("/api/v1/ecosystem/stats", get(get_ecosystem_stats))
            
            // ESG Integration endpoints
            .route("/api/v1/esg/unified-profile/:user_id", get(get_unified_esg_profile))
            .route("/api/v1/esg/transfer-unified", post(transfer_unified_tokens))
            .route("/api/v1/esg/platform-metrics/:user_id", get(get_platform_metrics));

    // Start the server
    let listener = TcpListener::bind("127.0.0.1:3000").await?;
    println!("🚀 ESG Token Ecosystem Rust Backend running on http://127.0.0.1:3000");
    println!("📊 Health check: http://127.0.0.1:3000/health");
    println!("📚 API Documentation: http://127.0.0.1:3000/docs");
    
    axum::serve(listener, app).await?;
    
    Ok(())
}
