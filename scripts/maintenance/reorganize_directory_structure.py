#!/usr/bin/env python3
"""
Script para reorganizar a estrutura de diretórios do ecosystem-degov
Data: 12/10/2025
Objetivo: Implementar estrutura enterprise-grade
"""

import os
import shutil
import json
from pathlib import Path
from datetime import datetime

class DirectoryReorganizer:
    def __init__(self, root_path="."):
        self.root_path = Path(root_path)
        self.log = []
        self.created_dirs = []
        self.moved_files = []
        
    def log_action(self, action, details):
        """Registra uma ação realizada"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.log.append(f"[{timestamp}] {action}: {details}")
        print(f"✅ {action}: {details}")
    
    def create_directory_structure(self):
        """Cria a nova estrutura de diretórios"""
        print("🏗️ Criando nova estrutura de diretórios...")
        
        # Estrutura principal
        directories = [
            # GitHub workflows
            ".github/workflows",
            ".github/templates",
            
            # VS Code
            ".vscode",
            
            # Smart contracts organizados
            "contracts/tokens",
            "contracts/interfaces", 
            "contracts/governance",
            "contracts/staking",
            "contracts/utils",
            
            # Deployments
            "deployments/mainnet",
            "deployments/testnet", 
            "deployments/local",
            
            # Documentação organizada
            "docs/architecture",
            "docs/api",
            "docs/user-guides",
            "docs/developer",
            "docs/investor",
            "docs/security",
            "docs/whitepaper",
            
            # Backend Rust
            "src/api",
            "src/services",
            "src/models",
            "src/utils",
            
            # Testes organizados
            "tests/unit",
            "tests/integration",
            "tests/e2e",
            "tests/contracts",
            
            # Scripts organizados
            "scripts/deploy",
            "scripts/test",
            "scripts/maintenance",
            
            # Configurações
            "config",
            "docker",
        ]
        
        for directory in directories:
            dir_path = self.root_path / directory
            if not dir_path.exists():
                dir_path.mkdir(parents=True, exist_ok=True)
                self.created_dirs.append(str(directory))
                self.log_action("DIRECTORY_CREATED", str(directory))
    
    def move_smart_contracts(self):
        """Move smart contracts para contracts/tokens/"""
        print("📄 Movendo smart contracts...")
        
        # Tokens na raiz que devem ser movidos
        tokens_in_root = [
            "AETToken.sol",
            "CCRToken.sol", 
            "ECRToken.sol",
            "ECSToken.sol",
            "ECTToken.sol",
            "EGMToken.sol",
            "ESTToken.sol",
            "IESToken.sol"
        ]
        
        for token_file in tokens_in_root:
            source = self.root_path / token_file
            if source.exists():
                destination = self.root_path / "contracts" / "tokens" / token_file
                shutil.move(str(source), str(destination))
                self.moved_files.append(f"{token_file} -> contracts/tokens/")
                self.log_action("FILE_MOVED", f"{token_file} -> contracts/tokens/")
    
    def move_deployment_files(self):
        """Move arquivos de deployment para deployments/"""
        print("🚀 Movendo arquivos de deployment...")
        
        # Arquivos de deployment na raiz
        deployment_files = [
            "aet-deployment-info.json",
            "ect-ccr-deployment-info.json", 
            "simple-deployment-info.json"
        ]
        
        for deployment_file in deployment_files:
            source = self.root_path / deployment_file
            if source.exists():
                destination = self.root_path / "deployments" / "local" / deployment_file
                shutil.move(str(source), str(destination))
                self.moved_files.append(f"{deployment_file} -> deployments/local/")
                self.log_action("FILE_MOVED", f"{deployment_file} -> deployments/local/")
    
    def organize_documentation(self):
        """Organiza documentação em docs/"""
        print("📚 Organizando documentação...")
        
        # Mapeamento de arquivos de documentação
        doc_mapping = {
            # Arquivos na raiz que devem ser movidos
            "ECOSYSTEM_DESCRIPTION.md": "docs/architecture/",
            "EXECUTIVE_SUMMARY.md": "docs/investor/",
            "FINAL_IMPLEMENTATION_SUMMARY.md": "docs/developer/",
            "PROJECT_STATUS_12_10_2025.md": "docs/developer/",
            "ROADMAP_EXECUCAO.md": "docs/developer/",
            "TASK_LIST_DETALHADA.md": "docs/developer/",
            "TASKMAS_SUPERESCOPO.md": "docs/developer/",
            "TOKEN_SUPPLY_ANALYSIS.md": "docs/developer/",
            "SESSION.md": "docs/developer/",
            "NEXT_SESSION_GUIDE.md": "docs/developer/",
            "DIRECTORY_STRUCTURE_ANALYSIS.md": "docs/architecture/",
        }
        
        for source_file, target_dir in doc_mapping.items():
            source_path = self.root_path / source_file
            if source_path.exists():
                target_path = self.root_path / target_dir / source_file
                shutil.move(str(source_path), str(target_path))
                self.moved_files.append(f"{source_file} -> {target_dir}")
                self.log_action("FILE_MOVED", f"{source_file} -> {target_dir}")
    
    def move_config_files(self):
        """Move arquivos de configuração para config/"""
        print("⚙️ Movendo arquivos de configuração...")
        
        config_files = [
            "hardhat.config.js",
            "package.json",
            "package-lock.json",
            "Cargo.toml",
            "Cargo.lock",
            ".gitignore",
            "env.example"
        ]
        
        for config_file in config_files:
            source = self.root_path / config_file
            if source.exists():
                destination = self.root_path / "config" / config_file
                shutil.move(str(source), str(destination))
                self.moved_files.append(f"{config_file} -> config/")
                self.log_action("FILE_MOVED", f"{config_file} -> config/")
    
    def create_github_workflows(self):
        """Cria workflows do GitHub"""
        print("🔄 Criando workflows do GitHub...")
        
        # Workflow de CI/CD
        ci_workflow = """name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: |
          npm install
          cargo build
      - name: Run tests
        run: |
          npm test
          cargo test
      - name: Run security audit
        run: cargo audit
"""
        
        workflow_path = self.root_path / ".github" / "workflows" / "ci.yml"
        with open(workflow_path, 'w') as f:
            f.write(ci_workflow)
        
        self.log_action("FILE_CREATED", ".github/workflows/ci.yml")
    
    def create_vscode_config(self):
        """Cria configurações do VS Code"""
        print("🔧 Criando configurações do VS Code...")
        
        # Settings do VS Code
        vscode_settings = {
            "rust-analyzer.cargo.features": "all",
            "rust-analyzer.checkOnSave.command": "clippy",
            "editor.formatOnSave": True,
            "files.associations": {
                "*.sol": "solidity"
            }
        }
        
        settings_path = self.root_path / ".vscode" / "settings.json"
        with open(settings_path, 'w') as f:
            json.dump(vscode_settings, f, indent=2)
        
        self.log_action("FILE_CREATED", ".vscode/settings.json")
    
    def create_docker_config(self):
        """Cria configurações Docker"""
        print("🐳 Criando configurações Docker...")
        
        # Dockerfile para backend Rust
        dockerfile_backend = """FROM rust:1.70 as builder

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release

FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/esg_token_backend /usr/local/bin/

EXPOSE 8080
CMD ["esg_token_backend"]
"""
        
        dockerfile_path = self.root_path / "docker" / "Dockerfile.backend"
        with open(dockerfile_path, 'w') as f:
            f.write(dockerfile_backend)
        
        # Docker Compose
        docker_compose = """version: '3.8'

services:
  backend:
    build:
      context: ..
      dockerfile: docker/Dockerfile.backend
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/esg_tokens
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      POSTGRES_DB: esg_tokens
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
"""
        
        compose_path = self.root_path / "docker" / "docker-compose.yml"
        with open(compose_path, 'w') as f:
            f.write(docker_compose)
        
        self.log_action("FILE_CREATED", "docker/Dockerfile.backend")
        self.log_action("FILE_CREATED", "docker/docker-compose.yml")
    
    def generate_report(self):
        """Gera relatório da reorganização"""
        print("📊 Gerando relatório da reorganização...")
        
        report = {
            "timestamp": datetime.now().isoformat(),
            "summary": {
                "directories_created": len(self.created_dirs),
                "files_moved": len(self.moved_files),
                "actions_logged": len(self.log)
            },
            "directories_created": self.created_dirs,
            "files_moved": self.moved_files,
            "actions_log": self.log
        }
        
        report_path = self.root_path / "REORGANIZATION_REPORT.json"
        with open(report_path, 'w') as f:
            json.dump(report, f, indent=2)
        
        self.log_action("REPORT_GENERATED", "REORGANIZATION_REPORT.json")
    
    def run_reorganization(self):
        """Executa a reorganização completa"""
        print("🚀 Iniciando reorganização da estrutura de diretórios...")
        print("=" * 60)
        
        try:
            # 1. Criar estrutura de diretórios
            self.create_directory_structure()
            
            # 2. Mover smart contracts
            self.move_smart_contracts()
            
            # 3. Mover arquivos de deployment
            self.move_deployment_files()
            
            # 4. Organizar documentação
            self.organize_documentation()
            
            # 5. Mover arquivos de configuração
            self.move_config_files()
            
            # 6. Criar workflows do GitHub
            self.create_github_workflows()
            
            # 7. Criar configurações do VS Code
            self.create_vscode_config()
            
            # 8. Criar configurações Docker
            self.create_docker_config()
            
            # 9. Gerar relatório
            self.generate_report()
            
            print("=" * 60)
            print("✅ REORGANIZAÇÃO CONCLUÍDA COM SUCESSO!")
            print(f"📁 Diretórios criados: {len(self.created_dirs)}")
            print(f"📄 Arquivos movidos: {len(self.moved_files)}")
            print(f"📝 Ações registradas: {len(self.log)}")
            print("=" * 60)
            
        except Exception as e:
            print(f"❌ ERRO durante reorganização: {e}")
            raise

if __name__ == "__main__":
    reorganizer = DirectoryReorganizer()
    reorganizer.run_reorganization()
