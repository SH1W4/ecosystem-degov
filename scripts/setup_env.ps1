# Script Interativo de Configuração
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   CONFIGURAÇÃO AUTOMÁTICA ECOSYSTEM DEGOV" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Solicitar API Key
do {
    $apiKey = Read-Host "1. Cole sua API Key do Infura (32 caracteres)"
    $apiKey = $apiKey.Trim()
    if ($apiKey.Length -ne 32) {
        Write-Host "❌ Erro: A API Key deve ter 32 caracteres. Você colou $($apiKey.Length)." -ForegroundColor Red
    }
} while ($apiKey.Length -ne 32)

# 2. Solicitar Private Key
do {
    $privateKey = Read-Host "2. Cole sua Private Key (64 caracteres, sem 0x)"
    $privateKey = $privateKey.Trim()
    
    # Remover 0x se o usuário colou
    if ($privateKey.StartsWith("0x")) {
        $privateKey = $privateKey.Substring(2)
    }

    if ($privateKey.Length -ne 64) {
        Write-Host "❌ Erro: A Private Key deve ter 64 caracteres. Você colou $($privateKey.Length)." -ForegroundColor Red
        Write-Host "Dica: No MetaMask > Detalhes da Conta > Mostrar Chave Privada" -ForegroundColor Yellow
    }
} while ($privateKey.Length -ne 64)

# 3. Criar conteúdo do .env
$envContent = @"
# Sepolia Testnet Configuration
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/$apiKey
PRIVATE_KEY=$privateKey
ETHERSCAN_API_KEY=
"@

# 4. Salvar arquivo
Set-Content -Path ".env" -Value $envContent -Encoding UTF8

Write-Host ""
Write-Host "✅ Arquivo .env configurado com sucesso!" -ForegroundColor Green
Write-Host "🚀 Iniciando teste de conexão..." -ForegroundColor Cyan

# 5. Testar conexão
node scripts/test_standalone.js
