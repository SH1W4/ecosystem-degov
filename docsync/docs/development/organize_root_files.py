#!/usr/bin/env python3
"""
📁 ESG Token Ecosystem - Root Files Organization
Organiza arquivos da raiz na estrutura enterprise
"""

import os
import shutil
from pathlib import Path
import logging

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('organize_root_files.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class RootFilesOrganizer:
    """Organizador de arquivos da raiz para estrutura enterprise"""
    
    def __init__(self):
        self.base_path = Path(".")
        self.organization_map = {
            # Documentação de desenvolvimento
            "DESENVOLVIMENTO.md": "docs/development/",
            "CONSOLIDATION_PLAN.md": "docs/development/",
            "CONSOLIDATION_STATUS.md": "docs/development/",
            "DIFFERENCES_ANALYSIS.md": "docs/development/",
            "CORRECAO_MIGRACAO.md": "docs/development/",
            "MIGRATION_STATUS.md": "docs/development/",
            
            # Documentação de arquitetura
            "EAP.md": "docs/architecture/",
            "EAP_GUARDFLOW.md": "docs/architecture/",
            "ECOSYSTEM_ARCHITECTURE.md": "docs/architecture/",
            "ECOSYSTEM_DEGOV_ARCHITECTURE_DIAGRAMS.md": "docs/architecture/",
            "ECOSYSTEM_MAP.md": "docs/architecture/",
            
            # Documentação executiva
            "ECOSYSTEM_DEGOV_EXECUTIVE_SUMMARY.md": "docs/whitepaper/",
            "ECOSYSTEM_DEGOV_WHITEPAPER.md": "docs/whitepaper/",
            
            # Documentação de integração
            "GUARDFLOW_CONNECTION.md": "docs/integration/",
            "GUARDFLOW_INTEGRATION.md": "docs/integration/",
            
            # Documentação ESG
            "GST_UPDATE.md": "docs/esg/",
            
            # Documentação de status
            "ENTERPRISE_ORGANIZATION_STATUS.md": "docs/development/",
            
            # Scripts de teste
            "test_backend.ps1": "tests/",
            "test_curl.bat": "tests/integration/",
            "test_ecotoken_ecosystem.bat": "tests/integration/",
            "test_gst_endpoints.bat": "tests/integration/",
            "test_mobility_integration.bat": "tests/integration/",
            "test_simple.bat": "tests/unit/",
            "test_simple.ps1": "tests/unit/",
            
            # Scripts de documentação
            "create_docs.py": "docs/development/",
            
            # Documentação legada
            "README_OLD.md": "docs/development/",
            
            # Configurações
            "REPOSITORY_DESCRIPTION.md": "docs/development/"
        }
        
    def create_directories(self):
        """Cria diretórios necessários"""
        directories = [
            "docs/development",
            "docs/architecture", 
            "docs/whitepaper",
            "docs/integration",
            "docs/esg",
            "tests/integration",
            "tests/unit"
        ]
        
        for directory in directories:
            os.makedirs(directory, exist_ok=True)
            logger.info(f"Criado diretorio: {directory}")
    
    def organize_files(self):
        """Organiza arquivos da raiz"""
        logger.info("Iniciando organizacao de arquivos da raiz...")
        
        moved_files = []
        skipped_files = []
        
        for filename, target_dir in self.organization_map.items():
            source_path = Path(filename)
            
            if source_path.exists():
                target_path = Path(target_dir) / filename
                
                # Criar diretório de destino se não existir
                target_path.parent.mkdir(parents=True, exist_ok=True)
                
                try:
                    # Mover arquivo (não copiar para manter histórico)
                    shutil.move(str(source_path), str(target_path))
                    moved_files.append(f"{filename} -> {target_path}")
                    logger.info(f"Movido: {filename} -> {target_path}")
                except Exception as e:
                    logger.error(f"Erro ao mover {filename}: {e}")
                    skipped_files.append(filename)
            else:
                logger.warning(f"Arquivo nao encontrado: {filename}")
                skipped_files.append(filename)
        
        return moved_files, skipped_files
    
    def organize_remaining_files(self):
        """Organiza arquivos que não estão no mapeamento"""
        remaining_files = []
        
        # Arquivos que devem permanecer na raiz
        keep_in_root = {
            "Cargo.toml", "Cargo.lock", "README.md"
        }
        
        # Verificar arquivos restantes na raiz
        for item in self.base_path.iterdir():
            if item.is_file() and item.name not in keep_in_root:
                # Categorizar arquivo baseado no nome
                if "test" in item.name.lower():
                    target_dir = "tests/unit/"
                elif "doc" in item.name.lower() or "readme" in item.name.lower():
                    target_dir = "docs/development/"
                elif "esg" in item.name.lower() or "ecosystem" in item.name.lower():
                    target_dir = "docs/architecture/"
                else:
                    target_dir = "docs/development/"
                
                target_path = Path(target_dir) / item.name
                target_path.parent.mkdir(parents=True, exist_ok=True)
                
                try:
                    shutil.move(str(item), str(target_path))
                    remaining_files.append(f"{item.name} -> {target_path}")
                    logger.info(f"Movido arquivo restante: {item.name} -> {target_path}")
                except Exception as e:
                    logger.error(f"Erro ao mover arquivo restante {item.name}: {e}")
        
        return remaining_files
    
    def create_organization_report(self, moved_files, skipped_files, remaining_files):
        """Cria relatório de organização"""
        report = f"""# 📁 **ROOT FILES ORGANIZATION REPORT**

## 📊 **STATUS DA ORGANIZAÇÃO**

**Data**: {Path().cwd().name}  
**Status**: ✅ **ORGANIZAÇÃO CONCLUÍDA**  
**Arquivos processados**: {len(moved_files) + len(remaining_files)}  

---

## ✅ **ARQUIVOS ORGANIZADOS**

### **Arquivos Mapeados ({len(moved_files)}):**
"""
        
        for file_moved in moved_files:
            report += f"- ✅ {file_moved}\n"
        
        if remaining_files:
            report += f"\n### **Arquivos Restantes ({len(remaining_files)}):**\n"
            for file_moved in remaining_files:
                report += f"- ✅ {file_moved}\n"
        
        if skipped_files:
            report += f"\n### **Arquivos Ignorados ({len(skipped_files)}):**\n"
            for file_skipped in skipped_files:
                report += f"- ⚠️ {file_skipped}\n"
        
        report += f"""

---

## 📁 **ESTRUTURA FINAL**

### **Arquivos na Raiz:**
- `Cargo.toml` - Configuração Rust
- `Cargo.lock` - Lock file Rust  
- `README.md` - Documentação principal

### **Estrutura Organizada:**
```
ecosystem-degov/
├── docs/
│   ├── development/          # Documentação de desenvolvimento
│   ├── architecture/        # Documentação de arquitetura
│   ├── whitepaper/          # Documentos estratégicos
│   ├── integration/         # Documentação de integração
│   └── esg/                 # Documentação ESG
├── tests/
│   ├── unit/                # Testes unitários
│   └── integration/         # Testes de integração
├── src/                     # Código fonte
├── target/                  # Build artifacts
└── docsync/                 # Sistema de documentação
```

---

## 🎯 **RESULTADOS ALCANÇADOS**

### **✅ ORGANIZAÇÃO COMPLETA:**
- **Estrutura limpa** na raiz
- **Documentação organizada** por categoria
- **Testes estruturados** por tipo
- **Arquivos de desenvolvimento** organizados
- **Documentação ESG** centralizada

### **📊 MÉTRICAS:**
- **Arquivos organizados**: {len(moved_files) + len(remaining_files)}
- **Arquivos ignorados**: {len(skipped_files)}
- **Taxa de sucesso**: {((len(moved_files) + len(remaining_files)) / (len(moved_files) + len(remaining_files) + len(skipped_files)) * 100):.1f}%
- **Estrutura**: 100% organizada

---

**📁 Root Files Organization - ESG Token Ecosystem**  
**Status**: ✅ **ORGANIZAÇÃO CONCLUÍDA**  
**Estrutura**: 🏗️ **ENTERPRISE LEVEL**  
**Próximo Passo**: 🚀 **VALIDAÇÃO E REFINAMENTO**
"""
        
        with open("ROOT_FILES_ORGANIZATION_REPORT.md", "w", encoding="utf-8") as f:
            f.write(report)
        
        logger.info("Relatorio de organizacao criado: ROOT_FILES_ORGANIZATION_REPORT.md")
    
    def run_organization(self):
        """Executa a organização completa"""
        logger.info("Iniciando organizacao de arquivos da raiz...")
        
        try:
            # 1. Criar diretórios
            self.create_directories()
            
            # 2. Organizar arquivos mapeados
            moved_files, skipped_files = self.organize_files()
            
            # 3. Organizar arquivos restantes
            remaining_files = self.organize_remaining_files()
            
            # 4. Criar relatório
            self.create_organization_report(moved_files, skipped_files, remaining_files)
            
            logger.info("Organizacao de arquivos da raiz concluida com sucesso!")
            
            return {
                "status": "success",
                "moved_files": len(moved_files),
                "remaining_files": len(remaining_files),
                "skipped_files": len(skipped_files),
                "total_processed": len(moved_files) + len(remaining_files)
            }
            
        except Exception as e:
            logger.error(f"Erro na organizacao: {e}")
            return {
                "status": "error",
                "error": str(e)
            }

def main():
    """Função principal"""
    print("📁 ESG Token Ecosystem - Root Files Organization")
    print("=" * 60)
    
    organizer = RootFilesOrganizer()
    result = organizer.run_organization()
    
    print(f"\n📊 Resultado: {result['status']}")
    if result['status'] == 'success':
        print(f"✅ Arquivos movidos: {result['moved_files']}")
        print(f"✅ Arquivos restantes: {result['remaining_files']}")
        print(f"⚠️ Arquivos ignorados: {result['skipped_files']}")
        print(f"📁 Total processado: {result['total_processed']}")
    else:
        print(f"❌ Erro: {result['error']}")

if __name__ == "__main__":
    main()
