# Teste Simples do Backend Rust
Write-Host "🚀 Testando Backend Rust..." -ForegroundColor Green

# Aguardar backend
Start-Sleep -Seconds 2

# Teste 1: Health Check
Write-Host "`n📡 Testando Health Check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3000/health" -Method GET
    Write-Host "✅ Health Check OK!" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ Health Check falhou: $($_.Exception.Message)" -ForegroundColor Red
}

# Teste 2: ESG Metrics
Write-Host "`n📊 Testando ESG Metrics..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3000/esg/metrics" -Method GET
    Write-Host "✅ ESG Metrics OK!" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ ESG Metrics falhou: $($_.Exception.Message)" -ForegroundColor Red
}

# Teste 3: AI Text Analysis
Write-Host "`n🤖 Testando AI Text Analysis..." -ForegroundColor Yellow
$aiBody = @{
    analysis_type = "sentiment"
    text = "This is a positive message about sustainability"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3000/ai/analyze/text" -Method POST -Body $aiBody -ContentType "application/json"
    Write-Host "✅ AI Text Analysis OK!" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ AI Text Analysis falhou: $($_.Exception.Message)" -ForegroundColor Red
}

# Teste 4: AI Image Analysis
Write-Host "`n🖼️ Testando AI Image Analysis..." -ForegroundColor Yellow
$imageBody = @{
    analysis_type = "sustainability"
    image_url = "https://example.com/sustainable-product.jpg"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3000/ai/analyze/image" -Method POST -Body $imageBody -ContentType "application/json"
    Write-Host "✅ AI Image Analysis OK!" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ AI Image Analysis falhou: $($_.Exception.Message)" -ForegroundColor Red
}

# Teste 5: Blockchain Balance
Write-Host "`n⛓️ Testando Blockchain Balance..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:3000/blockchain/balance/ESG_TOKEN_001" -Method GET
    Write-Host "✅ Blockchain Balance OK!" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ Blockchain Balance falhou: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 Testes concluídos!" -ForegroundColor Green

