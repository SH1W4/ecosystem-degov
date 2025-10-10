use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use uuid::Uuid;

// ESG Metrics Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ESGMetrics {
    pub id: Uuid,
    pub entity_id: String,
    pub entity_type: EntityType,
    pub environmental: EnvironmentalMetrics,
    pub social: SocialMetrics,
    pub governance: GovernanceMetrics,
    pub timestamp: DateTime<Utc>,
    pub verified: bool,
    pub score: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum EntityType {
    Vehicle,
    Company,
    Project,
    Individual,
    Building,
    Fleet,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnvironmentalMetrics {
    pub carbon_footprint: CarbonFootprint,
    pub energy_efficiency: EnergyEfficiency,
    pub waste_management: WasteManagement,
    pub water_usage: WaterUsage,
    pub biodiversity: Biodiversity,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CarbonFootprint {
    pub scope1_emissions: f64, // tCO2
    pub scope2_emissions: f64, // tCO2
    pub scope3_emissions: f64, // tCO2
    pub total_emissions: f64,  // tCO2
    pub reduction_target: f64, // tCO2
    pub achievement_rate: f64, // %
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnergyEfficiency {
    pub total_consumption: f64,    // kWh
    pub renewable_energy: f64,     // %
    pub efficiency_rating: f64,   // km/kWh or similar
    pub optimization_gains: f64,   // %
    pub smart_grid_integration: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WasteManagement {
    pub total_waste: f64,          // kg
    pub recycled_waste: f64,      // kg
    pub recycling_rate: f64,       // %
    pub waste_reduction: f64,     // %
    pub circular_economy: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WaterUsage {
    pub total_consumption: f64,    // L
    pub water_efficiency: f64,     // L/unit
    pub water_recycling: f64,     // %
    pub conservation_measures: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Biodiversity {
    pub green_spaces: f64,        // m²
    pub biodiversity_index: f64,   // 0-100
    pub conservation_efforts: bool,
    pub ecosystem_services: f64,  // 0-100
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SocialMetrics {
    pub safety_score: f64,         // 0-100
    pub user_satisfaction: f64,    // 0-100
    pub community_impact: f64,     // 0-100
    pub accessibility_score: f64, // 0-100
    pub diversity_inclusion: f64, // 0-100
    pub employee_wellbeing: f64,  // 0-100
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GovernanceMetrics {
    pub transparency_score: f64,  // 0-100
    pub audit_frequency: i32,     // reports/year
    pub compliance_rate: f64,     // %
    pub stakeholder_engagement: f64, // 0-100
    pub risk_management: f64,      // 0-100
    pub ethical_practices: f64,   // 0-100
}

// Request/Response Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateMetricsRequest {
    pub entity_id: String,
    pub entity_type: EntityType,
    pub environmental: EnvironmentalMetrics,
    pub social: SocialMetrics,
    pub governance: GovernanceMetrics,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MetricsResponse {
    pub id: Uuid,
    pub entity_id: String,
    pub entity_type: EntityType,
    pub score: f64,
    pub verified: bool,
    pub timestamp: DateTime<Utc>,
    pub environmental: EnvironmentalMetrics,
    pub social: SocialMetrics,
    pub governance: GovernanceMetrics,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TokenizeRequest {
    pub metrics_id: Uuid,
    pub token_type: TokenType,
    pub amount: f64,
    pub blockchain: BlockchainType,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TokenType {
    CarbonCredit,
    EnergyToken,
    SocialToken,
    GovernanceToken,
    ESGToken,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum BlockchainType {
    Ethereum,
    Polygon,
    Celo,
    XRPL,
    Hyperledger,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TokenizeResponse {
    pub transaction_hash: String,
    pub token_id: String,
    pub amount: f64,
    pub blockchain: BlockchainType,
    pub timestamp: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnalyzeRequest {
    pub metrics_id: Uuid,
    pub analysis_type: AnalysisType,
    pub timeframe: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum AnalysisType {
    Trend,
    Benchmark,
    Risk,
    Opportunity,
    Compliance,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnalyzeResponse {
    pub metrics_id: Uuid,
    pub analysis_type: AnalysisType,
    pub insights: Vec<String>,
    pub recommendations: Vec<String>,
    pub risk_factors: Vec<String>,
    pub opportunities: Vec<String>,
    pub compliance_status: ComplianceStatus,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ComplianceStatus {
    pub gri_compliant: bool,
    pub sasb_compliant: bool,
    pub tcfd_compliant: bool,
    pub iso14064_compliant: bool,
    pub overall_score: f64,
}

// Carbon Footprint Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CarbonRequest {
    pub entity_id: String,
    pub entity_type: EntityType,
    pub activity_data: ActivityData,
    pub emission_factors: EmissionFactors,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ActivityData {
    pub distance: Option<f64>,      // km
    pub fuel_consumption: Option<f64>, // L
    pub energy_consumption: Option<f64>, // kWh
    pub waste_generated: Option<f64>, // kg
    pub water_consumption: Option<f64>, // L
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EmissionFactors {
    pub fuel_emission_factor: f64,  // kg CO2/L
    pub electricity_emission_factor: f64, // kg CO2/kWh
    pub waste_emission_factor: f64, // kg CO2/kg
    pub water_emission_factor: f64, // kg CO2/L
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CarbonResponse {
    pub entity_id: String,
    pub total_emissions: f64,        // kg CO2
    pub scope1_emissions: f64,      // kg CO2
    pub scope2_emissions: f64,     // kg CO2
    pub scope3_emissions: f64,     // kg CO2
    pub emission_intensity: f64,    // kg CO2/unit
    pub reduction_potential: f64,  // kg CO2
    pub carbon_credits: f64,       // credits
}

// Energy Efficiency Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnergyRequest {
    pub entity_id: String,
    pub entity_type: EntityType,
    pub energy_data: EnergyData,
    pub efficiency_targets: EfficiencyTargets,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnergyData {
    pub total_consumption: f64,     // kWh
    pub renewable_energy: f64,      // %
    pub energy_intensity: f64,     // kWh/unit
    pub peak_demand: f64,          // kW
    pub load_factor: f64,          // %
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EfficiencyTargets {
    pub target_consumption: f64,    // kWh
    pub target_renewable: f64,     // %
    pub target_intensity: f64,     // kWh/unit
    pub target_load_factor: f64,   // %
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct EnergyResponse {
    pub entity_id: String,
    pub current_efficiency: f64,   // %
    pub target_efficiency: f64,    // %
    pub efficiency_gap: f64,       // %
    pub energy_savings: f64,       // kWh
    pub cost_savings: f64,         // USD
    pub renewable_potential: f64,   // %
}

// Social Metrics Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SocialRequest {
    pub entity_id: String,
    pub entity_type: EntityType,
    pub social_data: SocialData,
    pub stakeholder_feedback: StakeholderFeedback,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SocialData {
    pub safety_incidents: i32,
    pub user_satisfaction: f64,    // 0-100
    pub community_engagement: f64, // 0-100
    pub accessibility_score: f64,  // 0-100
    pub diversity_index: f64,      // 0-100
    pub employee_satisfaction: f64, // 0-100
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct StakeholderFeedback {
    pub customer_feedback: f64,    // 0-100
    pub employee_feedback: f64,   // 0-100
    pub community_feedback: f64,  // 0-100
    pub investor_feedback: f64,   // 0-100
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SocialResponse {
    pub entity_id: String,
    pub overall_score: f64,        // 0-100
    pub safety_score: f64,         // 0-100
    pub satisfaction_score: f64,   // 0-100
    pub community_score: f64,      // 0-100
    pub accessibility_score: f64,   // 0-100
    pub diversity_score: f64,      // 0-100
    pub improvement_areas: Vec<String>,
}

// Governance Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GovernanceRequest {
    pub entity_id: String,
    pub entity_type: EntityType,
    pub governance_data: GovernanceData,
    pub compliance_requirements: ComplianceRequirements,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GovernanceData {
    pub transparency_score: f64,   // 0-100
    pub audit_frequency: i32,       // reports/year
    pub compliance_rate: f64,       // %
    pub stakeholder_engagement: f64, // 0-100
    pub risk_management: f64,       // 0-100
    pub ethical_practices: f64,    // 0-100
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ComplianceRequirements {
    pub gri_required: bool,
    pub sasb_required: bool,
    pub tcfd_required: bool,
    pub iso14064_required: bool,
    pub local_regulations: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GovernanceResponse {
    pub entity_id: String,
    pub overall_score: f64,        // 0-100
    pub transparency_score: f64,   // 0-100
    pub compliance_score: f64,     // 0-100
    pub engagement_score: f64,     // 0-100
    pub risk_score: f64,          // 0-100
    pub ethical_score: f64,        // 0-100
    pub compliance_status: ComplianceStatus,
    pub improvement_recommendations: Vec<String>,
}

// AI Models
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIInsightsRequest {
    pub metrics_id: Uuid,
    pub insight_type: InsightType,
    pub context: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum InsightType {
    Trend,
    Anomaly,
    Pattern,
    Correlation,
    Prediction,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIInsightsResponse {
    pub metrics_id: Uuid,
    pub insight_type: InsightType,
    pub insights: Vec<Insight>,
    pub confidence: f64,
    pub timestamp: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Insight {
    pub title: String,
    pub description: String,
    pub impact: ImpactLevel,
    pub actionable: bool,
    pub priority: Priority,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ImpactLevel {
    Low,
    Medium,
    High,
    Critical,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Priority {
    Low,
    Medium,
    High,
    Urgent,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIPredictionsRequest {
    pub entity_id: String,
    pub prediction_type: PredictionType,
    pub timeframe: String,
    pub historical_data: Option<Vec<HistoricalData>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum PredictionType {
    CarbonEmissions,
    EnergyConsumption,
    SocialImpact,
    GovernanceScore,
    OverallESG,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HistoricalData {
    pub timestamp: DateTime<Utc>,
    pub value: f64,
    pub context: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIPredictionsResponse {
    pub entity_id: String,
    pub prediction_type: PredictionType,
    pub predictions: Vec<Prediction>,
    pub confidence: f64,
    pub model_version: String,
    pub timestamp: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Prediction {
    pub timestamp: DateTime<Utc>,
    pub predicted_value: f64,
    pub confidence_interval: (f64, f64),
    pub factors: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIRecommendationsRequest {
    pub entity_id: String,
    pub recommendation_type: RecommendationType,
    pub constraints: Option<Constraints>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum RecommendationType {
    CarbonReduction,
    EnergyOptimization,
    SocialImprovement,
    GovernanceEnhancement,
    OverallESG,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Constraints {
    pub budget: Option<f64>,
    pub timeline: Option<String>,
    pub resources: Option<Vec<String>>,
    pub regulatory: Option<Vec<String>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AIRecommendationsResponse {
    pub entity_id: String,
    pub recommendation_type: RecommendationType,
    pub recommendations: Vec<Recommendation>,
    pub expected_impact: ImpactAssessment,
    pub implementation_plan: ImplementationPlan,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Recommendation {
    pub title: String,
    pub description: String,
    pub priority: Priority,
    pub impact: ImpactLevel,
    pub cost: Option<f64>,
    pub timeline: String,
    pub resources_required: Vec<String>,
    pub expected_benefits: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ImpactAssessment {
    pub carbon_reduction: f64,      // tCO2
    pub energy_savings: f64,        // kWh
    pub cost_savings: f64,         // USD
    pub social_benefits: f64,     // 0-100
    pub governance_improvement: f64, // 0-100
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ImplementationPlan {
    pub phases: Vec<Phase>,
    pub total_duration: String,
    pub total_cost: f64,
    pub success_metrics: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Phase {
    pub name: String,
    pub description: String,
    pub duration: String,
    pub cost: f64,
    pub deliverables: Vec<String>,
    pub dependencies: Vec<String>,
}
