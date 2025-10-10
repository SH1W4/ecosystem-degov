@echo off
echo 🚀 Testando Backend Rust ESG Token Ecosystem...
echo.

echo 📡 Testando Health Check...
curl -s http://127.0.0.1:3000/health
echo.
echo.

echo 📊 Testando ESG Metrics...
curl -s http://127.0.0.1:3000/esg/metrics
echo.
echo.

echo 🤖 Testando AI Text Analysis...
curl -s -X POST http://127.0.0.1:3000/ai/analyze/text -H "Content-Type: application/json" -d "{\"analysis_type\":\"sentiment\",\"text\":\"This is a positive message about sustainability\"}"
echo.
echo.

echo 🖼️ Testando AI Image Analysis...
curl -s -X POST http://127.0.0.1:3000/ai/analyze/image -H "Content-Type: application/json" -d "{\"analysis_type\":\"sustainability\",\"image_url\":\"https://example.com/sustainable-product.jpg\"}"
echo.
echo.

echo ⛓️ Testando Blockchain Balance...
curl -s http://127.0.0.1:3000/blockchain/balance/ESG_TOKEN_001
echo.
echo.

echo 🎉 Testes concluídos!
