use anyhow::Result;
use sqlx::{PgPool, Row};
use chrono::{DateTime, Utc};
use uuid::Uuid;

pub struct Database {
    pub pool: PgPool,
}

impl Database {
    pub async fn new() -> Result<Self> {
        // Initialize database connection
        let database_url = std::env::var("DATABASE_URL")
            .unwrap_or_else(|_| "postgresql://user:password@localhost/esg_tokens".to_string());
        
        let pool = PgPool::connect(&database_url).await?;
        
        // Run migrations
        sqlx::migrate!("./migrations").run(&pool).await?;
        
        Ok(Self { pool })
    }

    pub async fn create_metrics(&self, metrics: &crate::models::ESGMetrics) -> Result<Uuid> {
        let id = metrics.id;
        let entity_id = &metrics.entity_id;
        let entity_type = format!("{:?}", metrics.entity_type);
        let timestamp = metrics.timestamp;
        let verified = metrics.verified;
        let score = metrics.score;

        sqlx::query!(
            r#"
            INSERT INTO esg_metrics (id, entity_id, entity_type, timestamp, verified, score)
            VALUES ($1, $2, $3, $4, $5, $6)
            "#,
            id,
            entity_id,
            entity_type,
            timestamp,
            verified,
            score
        )
        .execute(&self.pool)
        .await?;

        Ok(id)
    }

    pub async fn get_metrics(&self, id: &Uuid) -> Result<Option<crate::models::ESGMetrics>> {
        let row = sqlx::query!(
            r#"
            SELECT id, entity_id, entity_type, timestamp, verified, score
            FROM esg_metrics
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await?;

        if let Some(row) = row {
            // In a real implementation, you would also fetch the environmental, social, and governance data
            // For now, return a mock metrics object
            Ok(Some(crate::models::ESGMetrics {
                id: row.id,
                entity_id: row.entity_id,
                entity_type: crate::models::EntityType::Company, // This would be parsed from the database
                environmental: crate::models::EnvironmentalMetrics {
                    carbon_footprint: crate::models::CarbonFootprint {
                        scope1_emissions: 100.0,
                        scope2_emissions: 50.0,
                        scope3_emissions: 200.0,
                        total_emissions: 350.0,
                        reduction_target: 50.0,
                        achievement_rate: 0.7,
                    },
                    energy_efficiency: crate::models::EnergyEfficiency {
                        total_consumption: 1000.0,
                        renewable_energy: 0.3,
                        efficiency_rating: 0.8,
                        optimization_gains: 0.15,
                        smart_grid_integration: true,
                    },
                    waste_management: crate::models::WasteManagement {
                        total_waste: 500.0,
                        recycled_waste: 300.0,
                        recycling_rate: 0.6,
                        waste_reduction: 0.2,
                        circular_economy: true,
                    },
                    water_usage: crate::models::WaterUsage {
                        total_consumption: 10000.0,
                        water_efficiency: 0.9,
                        water_recycling: 0.4,
                        conservation_measures: true,
                    },
                    biodiversity: crate::models::Biodiversity {
                        green_spaces: 1000.0,
                        biodiversity_index: 75.0,
                        conservation_efforts: true,
                        ecosystem_services: 80.0,
                    },
                },
                social: crate::models::SocialMetrics {
                    safety_score: 85.0,
                    user_satisfaction: 90.0,
                    community_impact: 75.0,
                    accessibility_score: 80.0,
                    diversity_inclusion: 70.0,
                    employee_wellbeing: 85.0,
                },
                governance: crate::models::GovernanceMetrics {
                    transparency_score: 80.0,
                    audit_frequency: 4,
                    compliance_rate: 0.9,
                    stakeholder_engagement: 75.0,
                    risk_management: 85.0,
                    ethical_practices: 90.0,
                },
                timestamp: row.timestamp,
                verified: row.verified,
                score: row.score,
            }))
        } else {
            Ok(None)
        }
    }

    pub async fn update_metrics(&self, id: &Uuid, score: f64, verified: bool) -> Result<()> {
        sqlx::query!(
            r#"
            UPDATE esg_metrics
            SET score = $1, verified = $2, updated_at = $3
            WHERE id = $4
            "#,
            score,
            verified,
            Utc::now(),
            id
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn delete_metrics(&self, id: &Uuid) -> Result<()> {
        sqlx::query!(
            r#"
            DELETE FROM esg_metrics
            WHERE id = $1
            "#,
            id
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn list_metrics(&self, limit: Option<i64>, offset: Option<i64>) -> Result<Vec<crate::models::ESGMetrics>> {
        let limit = limit.unwrap_or(100);
        let offset = offset.unwrap_or(0);

        let rows = sqlx::query!(
            r#"
            SELECT id, entity_id, entity_type, timestamp, verified, score
            FROM esg_metrics
            ORDER BY timestamp DESC
            LIMIT $1 OFFSET $2
            "#,
            limit,
            offset
        )
        .fetch_all(&self.pool)
        .await?;

        let mut metrics = Vec::new();
        for row in rows {
            // In a real implementation, you would also fetch the environmental, social, and governance data
            // For now, return a mock metrics object
            metrics.push(crate::models::ESGMetrics {
                id: row.id,
                entity_id: row.entity_id,
                entity_type: crate::models::EntityType::Company, // This would be parsed from the database
                environmental: crate::models::EnvironmentalMetrics {
                    carbon_footprint: crate::models::CarbonFootprint {
                        scope1_emissions: 100.0,
                        scope2_emissions: 50.0,
                        scope3_emissions: 200.0,
                        total_emissions: 350.0,
                        reduction_target: 50.0,
                        achievement_rate: 0.7,
                    },
                    energy_efficiency: crate::models::EnergyEfficiency {
                        total_consumption: 1000.0,
                        renewable_energy: 0.3,
                        efficiency_rating: 0.8,
                        optimization_gains: 0.15,
                        smart_grid_integration: true,
                    },
                    waste_management: crate::models::WasteManagement {
                        total_waste: 500.0,
                        recycled_waste: 300.0,
                        recycling_rate: 0.6,
                        waste_reduction: 0.2,
                        circular_economy: true,
                    },
                    water_usage: crate::models::WaterUsage {
                        total_consumption: 10000.0,
                        water_efficiency: 0.9,
                        water_recycling: 0.4,
                        conservation_measures: true,
                    },
                    biodiversity: crate::models::Biodiversity {
                        green_spaces: 1000.0,
                        biodiversity_index: 75.0,
                        conservation_efforts: true,
                        ecosystem_services: 80.0,
                    },
                },
                social: crate::models::SocialMetrics {
                    safety_score: 85.0,
                    user_satisfaction: 90.0,
                    community_impact: 75.0,
                    accessibility_score: 80.0,
                    diversity_inclusion: 70.0,
                    employee_wellbeing: 85.0,
                },
                governance: crate::models::GovernanceMetrics {
                    transparency_score: 80.0,
                    audit_frequency: 4,
                    compliance_rate: 0.9,
                    stakeholder_engagement: 75.0,
                    risk_management: 85.0,
                    ethical_practices: 90.0,
                },
                timestamp: row.timestamp,
                verified: row.verified,
                score: row.score,
            });
        }

        Ok(metrics)
    }

    pub async fn create_token_transaction(&self, transaction: &TokenTransaction) -> Result<Uuid> {
        let id = transaction.id;
        let token_id = &transaction.token_id;
        let from_address = &transaction.from_address;
        let to_address = &transaction.to_address;
        let amount = transaction.amount;
        let transaction_hash = &transaction.transaction_hash;
        let status = format!("{:?}", transaction.status);
        let timestamp = transaction.timestamp;

        sqlx::query!(
            r#"
            INSERT INTO token_transactions (id, token_id, from_address, to_address, amount, transaction_hash, status, timestamp)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            "#,
            id,
            token_id,
            from_address,
            to_address,
            amount,
            transaction_hash,
            status,
            timestamp
        )
        .execute(&self.pool)
        .await?;

        Ok(id)
    }

    pub async fn get_token_transaction(&self, id: &Uuid) -> Result<Option<TokenTransaction>> {
        let row = sqlx::query!(
            r#"
            SELECT id, token_id, from_address, to_address, amount, transaction_hash, status, timestamp
            FROM token_transactions
            WHERE id = $1
            "#,
            id
        )
        .fetch_optional(&self.pool)
        .await?;

        if let Some(row) = row {
            Ok(Some(TokenTransaction {
                id: row.id,
                token_id: row.token_id,
                from_address: row.from_address,
                to_address: row.to_address,
                amount: row.amount,
                transaction_hash: row.transaction_hash,
                status: crate::models::TransactionStatusType::Confirmed, // This would be parsed from the database
                timestamp: row.timestamp,
            }))
        } else {
            Ok(None)
        }
    }

    pub async fn update_transaction_status(&self, id: &Uuid, status: crate::models::TransactionStatusType) -> Result<()> {
        let status_str = format!("{:?}", status);
        
        sqlx::query!(
            r#"
            UPDATE token_transactions
            SET status = $1, updated_at = $2
            WHERE id = $3
            "#,
            status_str,
            Utc::now(),
            id
        )
        .execute(&self.pool)
        .await?;

        Ok(())
    }

    pub async fn get_token_balance(&self, token_id: &str, address: &str) -> Result<f64> {
        let row = sqlx::query!(
            r#"
            SELECT COALESCE(SUM(amount), 0) as balance
            FROM token_transactions
            WHERE token_id = $1 AND to_address = $2
            "#,
            token_id,
            address
        )
        .fetch_one(&self.pool)
        .await?;

        Ok(row.balance.unwrap_or(0.0))
    }

    pub async fn get_transaction_history(&self, address: &str, limit: Option<i64>) -> Result<Vec<TokenTransaction>> {
        let limit = limit.unwrap_or(100);

        let rows = sqlx::query!(
            r#"
            SELECT id, token_id, from_address, to_address, amount, transaction_hash, status, timestamp
            FROM token_transactions
            WHERE from_address = $1 OR to_address = $1
            ORDER BY timestamp DESC
            LIMIT $2
            "#,
            address,
            limit
        )
        .fetch_all(&self.pool)
        .await?;

        let mut transactions = Vec::new();
        for row in rows {
            transactions.push(TokenTransaction {
                id: row.id,
                token_id: row.token_id,
                from_address: row.from_address,
                to_address: row.to_address,
                amount: row.amount,
                transaction_hash: row.transaction_hash,
                status: crate::models::TransactionStatusType::Confirmed, // This would be parsed from the database
                timestamp: row.timestamp,
            });
        }

        Ok(transactions)
    }
}

#[derive(Debug, Clone)]
pub struct TokenTransaction {
    pub id: Uuid,
    pub token_id: String,
    pub from_address: String,
    pub to_address: String,
    pub amount: f64,
    pub transaction_hash: String,
    pub status: crate::models::TransactionStatusType,
    pub timestamp: DateTime<Utc>,
}


