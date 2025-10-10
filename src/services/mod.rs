use anyhow::Result;
use std::collections::HashMap;

pub mod esg_service;
pub mod ai_service;
pub mod blockchain_service;
pub mod database_service;

pub struct ServiceManager {
    pub services: HashMap<String, Box<dyn Service>>,
}

pub trait Service {
    fn name(&self) -> &str;
    fn version(&self) -> &str;
    fn health_check(&self) -> Result<ServiceHealth>;
    fn start(&mut self) -> Result<()>;
    fn stop(&mut self) -> Result<()>;
    fn restart(&mut self) -> Result<()>;
}

#[derive(Debug, Clone)]
pub struct ServiceHealth {
    pub status: ServiceStatus,
    pub uptime: u64,
    pub memory_usage: f64,
    pub cpu_usage: f64,
    pub last_check: chrono::DateTime<chrono::Utc>,
}

#[derive(Debug, Clone)]
pub enum ServiceStatus {
    Healthy,
    Unhealthy,
    Degraded,
    Unknown,
}

impl ServiceManager {
    pub fn new() -> Self {
        Self {
            services: HashMap::new(),
        }
    }

    pub fn register_service(&mut self, name: String, service: Box<dyn Service>) {
        self.services.insert(name, service);
    }

    pub fn get_service(&self, name: &str) -> Option<&Box<dyn Service>> {
        self.services.get(name)
    }

    pub fn get_service_mut(&mut self, name: &str) -> Option<&mut Box<dyn Service>> {
        self.services.get_mut(name)
    }

    pub fn start_all_services(&mut self) -> Result<()> {
        for (name, service) in self.services.iter_mut() {
            service.start()?;
            println!("Started service: {}", name);
        }
        Ok(())
    }

    pub fn stop_all_services(&mut self) -> Result<()> {
        for (name, service) in self.services.iter_mut() {
            service.stop()?;
            println!("Stopped service: {}", name);
        }
        Ok(())
    }

    pub fn restart_all_services(&mut self) -> Result<()> {
        for (name, service) in self.services.iter_mut() {
            service.restart()?;
            println!("Restarted service: {}", name);
        }
        Ok(())
    }

    pub fn health_check_all(&self) -> HashMap<String, ServiceHealth> {
        let mut health_status = HashMap::new();
        
        for (name, service) in self.services.iter() {
            match service.health_check() {
                Ok(health) => {
                    health_status.insert(name.clone(), health);
                },
                Err(e) => {
                    health_status.insert(name.clone(), ServiceHealth {
                        status: ServiceStatus::Unhealthy,
                        uptime: 0,
                        memory_usage: 0.0,
                        cpu_usage: 0.0,
                        last_check: chrono::Utc::now(),
                    });
                }
            }
        }
        
        health_status
    }
}

