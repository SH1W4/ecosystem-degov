@echo off
echo 🎉 Testando EcoToken Hybrid Ecosystem...
echo.

:: Aguardar o backend iniciar (opcional, ajuste o tempo conforme necessário)
echo ⏳ Aguardando backend iniciar...
timeout /t 5 /nobreak > nul
echo.

echo 🏥 Testando Health Check...
curl -s http://127.0.0.1:3000/health
echo.

echo 🌱 Testando EcoToken (ECT) Info...
curl -s http://127.0.0.1:3000/api/v1/ecotoken/info
echo.

echo 💰 Testando EcoToken Balance...
curl -s http://127.0.0.1:3000/api/v1/ecotoken/balance/0x123abc
echo.

echo 💸 Testando EcoToken Transfer...
curl -s -X POST http://127.0.0.1:3000/api/v1/ecotoken/transfer -H "Content-Type: application/json" -d "{\"from\": \"0x123abc\", \"to\": \"0x456def\", \"amount\": \"100\"}"
echo.

echo 🏆 Testando EcoScore Profile...
curl -s http://127.0.0.1:3000/api/v1/ecoscore/profile/user123
echo.

echo 🎯 Testando EcoScore Mint...
curl -s -X POST http://127.0.0.1:3000/api/v1/ecoscore/mint -H "Content-Type: application/json" -d "{\"user_id\": \"user123\", \"amount\": \"500\", \"reason\": \"Carbon Reduction\"}"
echo.

echo 🌍 Testando Carbon Credits Balance...
curl -s http://127.0.0.1:3000/api/v1/carboncredits/balance/user123
echo.

echo 🔥 Testando Carbon Credits Mint...
curl -s -X POST http://127.0.0.1:3000/api/v1/carboncredits/mint -H "Content-Type: application/json" -d "{\"user_id\": \"user123\", \"amount\": \"100\", \"verification_id\": \"VER-001\"}"
echo.

echo 📄 Testando Certificate Mint...
curl -s -X POST http://127.0.0.1:3000/api/v1/certificates/mint -H "Content-Type: application/json" -d "{\"user_id\": \"user123\", \"certificate_type\": \"Carbon Neutral\", \"impact_score\": \"850\", \"rarity\": \"3\", \"metadata\": \"Carbon neutral certification\"}"
echo.

echo 🏢 Testando EcoStake Position...
curl -s http://127.0.0.1:3000/api/v1/ecostake/position/user123
echo.

echo 💎 Testando EcoGem Balance...
curl -s http://127.0.0.1:3000/api/v1/ecogem/balance/user123
echo.

echo 👑 Testando VIP Status...
curl -s http://127.0.0.1:3000/api/v1/ecogem/vip/user123
echo.

echo 🔄 Testando Unified Ecosystem Balance...
curl -s http://127.0.0.1:3000/api/v1/ecosystem/balance/user123
echo.

echo 📊 Testando Ecosystem Stats...
curl -s http://127.0.0.1:3000/api/v1/ecosystem/stats
echo.

echo 🎉 Testes do EcoToken Hybrid Ecosystem concluídos!
pause
