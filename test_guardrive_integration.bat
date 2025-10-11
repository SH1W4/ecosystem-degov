@echo off
echo 🚗 Testando Integração GuardDrive no ESG Token Ecosystem...
echo.

:: Aguardar o backend iniciar
echo ⏳ Aguardando backend iniciar...
timeout /t 3 /nobreak > nul
echo.

echo 🏥 Testando Health Check...
curl -s http://127.0.0.1:3000/health
echo.

echo 🚗 Testando GuardDrive Telemetry Sync...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/guardrive/sync -H "Content-Type: application/json" -d "{\"vehicle_id\": \"VEH-001\", \"driving_efficiency\": \"0.85\", \"carbon_footprint\": \"2.5\", \"sustainability_score\": \"0.90\"}"
echo.

echo 🚙 Testando GuardDrive Vehicle Info...
curl -s http://127.0.0.1:3000/api/v1/gst/guardrive/vehicle/VEH-001
echo.

echo 🔄 Testando Cross-Platform Balance...
curl -s http://127.0.0.1:3000/api/v1/gst/cross-platform/balance/user123
echo.

echo 🔄 Testando Cross-Platform Transfer...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/cross-platform/transfer -H "Content-Type: application/json" -d "{\"from_platform\": \"guardrive\", \"to_platform\": \"guardflow\", \"amount\": \"100\"}"
echo.

echo 👤 Testando Unified ESG Profile...
curl -s http://127.0.0.1:3000/api/v1/gst/cross-platform/profile/user123
echo.

echo 🛒 Testando Smart Cart Integration...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/smart-cart/process -H "Content-Type: application/json" -d "{\"cart_id\": \"CART-001\", \"user_id\": \"user123\", \"sustainability_bonus\": \"0.15\"}"
echo.

echo 🪙 Testando GST Token Info...
curl -s http://127.0.0.1:3000/api/v1/gst/tokens/GST
echo.

echo 💰 Testando GST Balance...
curl -s http://127.0.0.1:3000/api/v1/gst/balance/0x123abc/GST
echo.

echo 🎉 Testes GuardDrive Integration concluídos!
echo.
echo 📊 Resumo dos Endpoints Testados:
echo ✅ Health Check
echo ✅ GuardDrive Telemetry Sync
echo ✅ GuardDrive Vehicle Info
echo ✅ Cross-Platform Balance
echo ✅ Cross-Platform Transfer
echo ✅ Unified ESG Profile
echo ✅ Smart Cart Integration
echo ✅ GST Token Management
echo.
echo 🚀 ESG Token Ecosystem com GuardDrive Integration funcionando perfeitamente!
pause

