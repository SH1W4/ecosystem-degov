use axum::{
    extract::{Path, Query, State},
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use tower_http::cors::CorsLayer;
use tracing::{info, warn};

mod ai;
mod blockchain;
mod database;
mod esg;
mod models;
mod services;

use models::*;
use services::*;

#[derive(Clone)]
pub struct AppState {
    pub db: database::Database,
    pub blockchain: blockchain::BlockchainService,
    pub ai: ai::AIService,
    pub esg: esg::ESGService,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize tracing
    tracing_subscriber::fmt::init();

    info!("Starting ESG Token Ecosystem Backend");

    // Initialize services
    let db = database::Database::new().await?;
    let blockchain = blockchain::BlockchainService::new().await?;
    let ai = ai::AIService::new().await?;
    let esg = esg::ESGService::new().await?;

    let state = AppState {
        db,
        blockchain,
        ai,
        esg,
    };

    // Build router
    let app = Router::new()
        .route("/health", get(health_check))
        .route("/api/v1/metrics", post(create_metrics))
        .route("/api/v1/metrics/:id", get(get_metrics))
        .route("/api/v1/tokenize", post(tokenize_metrics))
        .route("/api/v1/analyze", post(analyze_metrics))
        .route("/api/v1/carbon", post(calculate_carbon))
        .route("/api/v1/energy", post(calculate_energy))
        .route("/api/v1/social", post(calculate_social))
        .route("/api/v1/governance", post(calculate_governance))
        .route("/api/v1/ai/insights", post(get_ai_insights))
        .route("/api/v1/ai/predictions", post(get_ai_predictions))
        .route("/api/v1/ai/recommendations", post(get_ai_recommendations))
        .layer(CorsLayer::permissive())
        .with_state(state);

    // Start server
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    info!("Server running on http://0.0.0.0:3000");
    
    axum::serve(listener, app).await?;

    Ok(())
}

// Health check endpoint
async fn health_check() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "status": "healthy",
        "service": "ESG Token Ecosystem",
        "version": "1.0.0",
        "timestamp": chrono::Utc::now()
    }))
}

// Create ESG metrics
async fn create_metrics(
    State(state): State<AppState>,
    Json(payload): Json<CreateMetricsRequest>,
) -> Result<Json<MetricsResponse>, StatusCode> {
    info!("Creating ESG metrics: {:?}", payload);
    
    match state.esg.create_metrics(payload).await {
        Ok(metrics) => Ok(Json(metrics)),
        Err(e) => {
            warn!("Failed to create metrics: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Get metrics by ID
async fn get_metrics(
    State(state): State<AppState>,
    Path(id): Path<String>,
) -> Result<Json<MetricsResponse>, StatusCode> {
    info!("Getting metrics: {}", id);
    
    match state.esg.get_metrics(&id).await {
        Ok(Some(metrics)) => Ok(Json(metrics)),
        Ok(None) => Err(StatusCode::NOT_FOUND),
        Err(e) => {
            warn!("Failed to get metrics: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Tokenize metrics
async fn tokenize_metrics(
    State(state): State<AppState>,
    Json(payload): Json<TokenizeRequest>,
) -> Result<Json<TokenizeResponse>, StatusCode> {
    info!("Tokenizing metrics: {:?}", payload);
    
    match state.blockchain.tokenize_metrics(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to tokenize metrics: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Analyze metrics with AI
async fn analyze_metrics(
    State(state): State<AppState>,
    Json(payload): Json<AnalyzeRequest>,
) -> Result<Json<AnalyzeResponse>, StatusCode> {
    info!("Analyzing metrics with AI: {:?}", payload);
    
    match state.ai.analyze_metrics(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to analyze metrics: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Calculate carbon footprint
async fn calculate_carbon(
    State(state): State<AppState>,
    Json(payload): Json<CarbonRequest>,
) -> Result<Json<CarbonResponse>, StatusCode> {
    info!("Calculating carbon footprint: {:?}", payload);
    
    match state.esg.calculate_carbon_footprint(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to calculate carbon: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Calculate energy efficiency
async fn calculate_energy(
    State(state): State<AppState>,
    Json(payload): Json<EnergyRequest>,
) -> Result<Json<EnergyResponse>, StatusCode> {
    info!("Calculating energy efficiency: {:?}", payload);
    
    match state.esg.calculate_energy_efficiency(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to calculate energy: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Calculate social metrics
async fn calculate_social(
    State(state): State<AppState>,
    Json(payload): Json<SocialRequest>,
) -> Result<Json<SocialResponse>, StatusCode> {
    info!("Calculating social metrics: {:?}", payload);
    
    match state.esg.calculate_social_metrics(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to calculate social metrics: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Calculate governance metrics
async fn calculate_governance(
    State(state): State<AppState>,
    Json(payload): Json<GovernanceRequest>,
) -> Result<Json<GovernanceResponse>, StatusCode> {
    info!("Calculating governance metrics: {:?}", payload);
    
    match state.esg.calculate_governance_metrics(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to calculate governance metrics: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Get AI insights
async fn get_ai_insights(
    State(state): State<AppState>,
    Json(payload): Json<AIInsightsRequest>,
) -> Result<Json<AIInsightsResponse>, StatusCode> {
    info!("Getting AI insights: {:?}", payload);
    
    match state.ai.get_insights(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to get AI insights: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Get AI predictions
async fn get_ai_predictions(
    State(state): State<AppState>,
    Json(payload): Json<AIPredictionsRequest>,
) -> Result<Json<AIPredictionsResponse>, StatusCode> {
    info!("Getting AI predictions: {:?}", payload);
    
    match state.ai.get_predictions(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to get AI predictions: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}

// Get AI recommendations
async fn get_ai_recommendations(
    State(state): State<AppState>,
    Json(payload): Json<AIRecommendationsRequest>,
) -> Result<Json<AIRecommendationsResponse>, StatusCode> {
    info!("Getting AI recommendations: {:?}", payload);
    
    match state.ai.get_recommendations(payload).await {
        Ok(response) => Ok(Json(response)),
        Err(e) => {
            warn!("Failed to get AI recommendations: {}", e);
            Err(StatusCode::INTERNAL_SERVER_ERROR)
        }
    }
}
