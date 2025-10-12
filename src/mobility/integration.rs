use anyhow::Result;
use serde::{Deserialize, Serialize};
use crate::mobility::bridge::{MobilityBridge, UnifiedCrossPlatformBalance, UnifiedCrossPlatformReward};
use std::collections::HashMap;

// Integration service for unified ESG Token Ecosystem
pub struct ESGIntegrationService {
    pub mobility_bridge: MobilityBridge,
}

impl ESGIntegrationService {
    pub async fn new() -> Result<Self> {
        let mobility_bridge = MobilityBridge::new().await?;
        
        Ok(Self {
            mobility_bridge,
        })
    }

    // Unified ESG Profile combining all platforms
    pub async fn get_unified_esg_profile(&self, user_id: &str) -> Result<UnifiedESGProfile> {
        let unified_balance = self.mobility_bridge.get_unified_balance(user_id).await?;
        let unified_reward = self.mobility_bridge.calculate_unified_reward(user_id).await?;
        let platform_metrics = self.mobility_bridge.get_platform_metrics(user_id).await?;
        
        Ok(UnifiedESGProfile {
            user_id: user_id.to_string(),
            // Tokens por plataforma
            guardrive_tokens: unified_balance.guardrive_tokens,
            guardflow_tokens: unified_balance.guardflow_tokens,
            // Tokens por funcionalidade
            mobility_tokens: unified_balance.mobility_tokens,
            sustainability_tokens: unified_balance.sustainability_tokens,
            // Totais
            total_unified_tokens: unified_balance.total_unified_tokens,
            cross_platform_multiplier: unified_balance.cross_platform_multiplier,
            // Métricas ESG
            esg_score: self.calculate_esg_score(&unified_balance).await?,
            sustainability_level: self.determine_sustainability_level(&unified_balance).await?,
            // Distribuições
            platform_distribution: unified_balance.platform_distribution.clone(),
            functionality_distribution: unified_balance.functionality_distribution.clone(),
            // Rewards
            unified_reward: unified_reward,
            // Métricas
            platform_metrics,
            // Achievements
            achievements: self.get_achievements(&unified_balance).await?,
        })
    }

    // Calculate ESG score based on unified balance
    async fn calculate_esg_score(&self, balance: &UnifiedCrossPlatformBalance) -> Result<f64> {
        let mobility_score = (balance.mobility_tokens as f64 / 1000.0) * 10.0;
        let sustainability_score = (balance.sustainability_tokens as f64 / 1000.0) * 10.0;
        let platform_score = (balance.guardrive_tokens + balance.guardflow_tokens) as f64 / 2000.0 * 10.0;
        
        let esg_score = (mobility_score + sustainability_score + platform_score) / 3.0;
        Ok(esg_score.min(10.0).max(0.0))
    }

    // Determine sustainability level based on unified balance
    async fn determine_sustainability_level(&self, balance: &UnifiedCrossPlatformBalance) -> Result<String> {
        let total_tokens = balance.total_unified_tokens;
        
        if total_tokens >= 10000 {
            Ok("Platinum".to_string())
        } else if total_tokens >= 5000 {
            Ok("Gold".to_string())
        } else if total_tokens >= 2000 {
            Ok("Silver".to_string())
        } else {
            Ok("Bronze".to_string())
        }
    }

    // Get achievements based on unified balance
    async fn get_achievements(&self, balance: &UnifiedCrossPlatformBalance) -> Result<Vec<String>> {
        let mut achievements = Vec::new();
        
        if balance.mobility_tokens >= 1000 {
            achievements.push("Eco Driver".to_string());
        }
        
        if balance.sustainability_tokens >= 1000 {
            achievements.push("Green Shopper".to_string());
        }
        
        if balance.guardrive_tokens >= 1000 {
            achievements.push("GuardDrive Champion".to_string());
        }
        
        if balance.guardflow_tokens >= 1000 {
            achievements.push("GuardFlow Expert".to_string());
        }
        
        if balance.total_unified_tokens >= 5000 {
            achievements.push("Sustainability Champion".to_string());
        }
        
        if balance.cross_platform_multiplier >= 2.0 {
            achievements.push("Cross-Platform Master".to_string());
        }
        
        Ok(achievements)
    }

    // Transfer tokens across all platforms
    pub async fn transfer_unified_tokens(&self, from_platform: &str, to_platform: &str, amount: u64) -> Result<u64> {
        self.mobility_bridge.transfer_tokens_unified(from_platform, to_platform, amount).await
    }

    // Get platform-specific metrics
    pub async fn get_platform_metrics(&self, user_id: &str) -> Result<HashMap<String, f64>> {
        self.mobility_bridge.get_platform_metrics(user_id).await
    }
}

// Unified ESG Profile structure
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UnifiedESGProfile {
    pub user_id: String,
    // Tokens por plataforma
    pub guardrive_tokens: u64,
    pub guardflow_tokens: u64,
    // Tokens por funcionalidade
    pub mobility_tokens: u64,
    pub sustainability_tokens: u64,
    // Totais
    pub total_unified_tokens: u64,
    pub cross_platform_multiplier: f64,
    // Métricas ESG
    pub esg_score: f64,
    pub sustainability_level: String,
    // Distribuições
    pub platform_distribution: HashMap<String, u64>,
    pub functionality_distribution: HashMap<String, u64>,
    // Rewards
    pub unified_reward: UnifiedCrossPlatformReward,
    // Métricas
    pub platform_metrics: HashMap<String, f64>,
    // Achievements
    pub achievements: Vec<String>,
}
