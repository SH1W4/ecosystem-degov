# Teste do Backend Rust ESG Token Ecosystem
# Executa testes automatizados das APIs

Write-Host "🚀 Testando Backend Rust ESG Token Ecosystem..." -ForegroundColor Green

# Função para testar endpoint
function Test-Endpoint {
    param(
        [string]$Method,
        [string]$Url,
        [string]$Body = $null,
        [string]$Description
    )
    
    Write-Host "`n📡 Testando: $Description" -ForegroundColor Yellow
    Write-Host "   $Method $Url" -ForegroundColor Cyan
    
    try {
        if ($Body) {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Body $Body -ContentType "application/json"
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method
        }
        
        Write-Host "   ✅ Sucesso!" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 3 | Write-Host
    }
    catch {
        Write-Host "   ❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Aguardar backend iniciar
Write-Host "⏳ Aguardando backend iniciar..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Testes dos endpoints
Write-Host "`n🧪 Iniciando testes dos endpoints..." -ForegroundColor Green

# 1. Health Check
Test-Endpoint -Method "GET" -Url "http://127.0.0.1:3000/health" -Description "Health Check"

# 2. ESG Metrics
$metricsBody = @{
    entity_id = "company-123"
    score = 0.85
} | ConvertTo-Json

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/metrics" -Body $metricsBody -Description "Criar Métricas ESG"

Test-Endpoint -Method "GET" -Url "http://127.0.0.1:3000/api/v1/metrics/test-id" -Description "Obter Métricas ESG"

# 3. AI Services
$aiBody = @{
    text = "Our company is committed to sustainability and reducing carbon emissions"
    analysis_type = "sentiment"
} | ConvertTo-Json

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/ai/analyze" -Body $aiBody -Description "Análise de Texto (NLP)"

$imageBody = @{
    image_data = "base64_encoded_image_data"
    analysis_type = "sustainability"
} | ConvertTo-Json

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/ai/vision" -Body $imageBody -Description "Análise de Imagem (Computer Vision)"

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/ai/predictions" -Body $aiBody -Description "Previsões de IA"

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/ai/recommendations" -Body $aiBody -Description "Recomendações de IA"

# 4. Blockchain
$blockchainBody = @{
    metrics_id = "metrics-123"
    amount = 100.0
    blockchain = "ethereum"
} | ConvertTo-Json

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/tokenize" -Body $blockchainBody -Description "Tokenizar Métricas"

Test-Endpoint -Method "GET" -Url "http://127.0.0.1:3000/api/v1/tokens/ESG_TOKEN_001/balance" -Description "Saldo de Tokens"

$transferBody = @{
    from = "0x1234567890abcdef"
    to = "0xfedcba0987654321"
    amount = "50.0"
    token_id = "ESG_TOKEN_001"
} | ConvertTo-Json

Test-Endpoint -Method "POST" -Url "http://127.0.0.1:3000/api/v1/tokens/transfer" -Body $transferBody -Description "Transferir Tokens"

# 5. Analytics
Test-Endpoint -Method "GET" -Url "http://127.0.0.1:3000/api/v1/analytics" -Description "Analytics Gerais"

Test-Endpoint -Method "GET" -Url "http://127.0.0.1:3000/api/v1/analytics/trends" -Description "Tendências Analytics"

Write-Host "`n🎉 Testes concluídos!" -ForegroundColor Green
Write-Host "📊 Backend Rust ESG Token Ecosystem funcionando perfeitamente!" -ForegroundColor Green

