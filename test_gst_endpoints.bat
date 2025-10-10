@echo off
echo 🎉 Testando Backend Rust com GST Integrado...
echo.

:: Aguardar o backend iniciar
echo ⏳ Aguardando backend iniciar...
timeout /t 3 /nobreak > nul
echo.

echo 🏥 Testando Health Check...
curl -s http://127.0.0.1:3000/health
echo.

echo 🌱 Testando GST Token Info...
curl -s http://127.0.0.1:3000/api/v1/gst/tokens/GST
echo.

echo 💰 Testando GST Balance...
curl -s http://127.0.0.1:3000/api/v1/gst/balance/0x123/GST
echo.

echo 💸 Testando GST Transfer...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/transfer -H "Content-Type: application/json" -d "{\"from\": \"0x123\", \"to\": \"0x456\", \"amount\": \"100\", \"token_id\": \"GST\"}"
echo.

echo 🛒 Testando GST Marketplace List...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/marketplace/list -H "Content-Type: application/json" -d "{\"seller\": \"0x123\", \"token_id\": \"GST\", \"price\": \"500\", \"quantity\": \"10\", \"description\": \"Eco Product\", \"category\": \"sustainability\"}"
echo.

echo 🛍️ Testando GST Marketplace Buy...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/marketplace/buy -H "Content-Type: application/json" -d "{\"buyer\": \"0x456\", \"item_id\": \"item_123\", \"quantity\": \"5\"}"
echo.

echo 🎮 Testando GST Gamification...
curl -s http://127.0.0.1:3000/api/v1/gst/gamification/user_123
echo.

echo 🏆 Testando GST Complete Mission...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/gamification/complete-mission -H "Content-Type: application/json" -d "{\"user_id\": \"user_123\", \"mission_id\": \"mission_1\"}"
echo.

echo 🏛️ Testando GST Governance Propose...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/governance/propose -H "Content-Type: application/json" -d "{\"proposer\": \"0x123\", \"title\": \"Increase GST Rewards\", \"description\": \"Proposal to increase GST rewards for sustainable purchases\"}"
echo.

echo 🗳️ Testando GST Governance Vote...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/governance/vote -H "Content-Type: application/json" -d "{\"voter\": \"0x456\", \"proposal_id\": \"prop_1\", \"vote\": \"true\"}"
echo.

echo 📄 Testando NFE to NFT Conversion...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/nfe/convert -H "Content-Type: application/json" -d "{\"nfe_id\": \"nfe_123\", \"owner\": \"0x789\", \"amount\": \"150.0\", \"sustainability_score\": \"0.85\"}"
echo.

echo 🛒 Testando Smart Cart Processing...
curl -s -X POST http://127.0.0.1:3000/api/v1/gst/smart-cart/process -H "Content-Type: application/json" -d "{\"cart_id\": \"cart_123\", \"user_id\": \"user_456\", \"sustainability_bonus\": \"0.8\"}"
echo.

echo 🎉 Testes GST concluídos!
pause
