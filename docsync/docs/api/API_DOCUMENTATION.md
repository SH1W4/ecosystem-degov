# 📚 **API DOCUMENTATION - ESG TOKEN ECOSYSTEM**

## 🎯 **VISÃO GERAL DA API**

A API do ESG Token Ecosystem fornece endpoints para tokenização ESG, gestão de tokens e integração cross-platform.

### **Base URL:**
```
https://api.ecosystem-degov.com
```

## 🔐 **AUTENTICAÇÃO**

### **JWT Token:**
```bash
Authorization: Bearer <your-jwt-token>
```

### **API Key:**
```bash
X-API-Key: <your-api-key>
```

## 📊 **ENDPOINTS PRINCIPAIS**

### **Health Check:**
- `GET /health` - Status do serviço

### **ESG Integration:**
- `GET /api/v1/esg/unified-profile/:user_id` - Perfil ESG unificado
- `POST /api/v1/esg/transfer-unified` - Transferência unificada
- `GET /api/v1/esg/platform-metrics/:user_id` - Métricas de plataforma

### **7 Tokens ESG:**
- **EcoToken (ECT)**: `GET /api/v1/ecotoken/balance/:address`
- **EcoScore (ECS)**: `GET /api/v1/ecoscore/profile/:user_id`
- **CarbonCredit (CCR)**: `GET /api/v1/carboncredits/balance/:user_id`
- **EcoCertificate (ECR)**: `GET /api/v1/certificates/user/:user_id`
- **EcoStake (EST)**: `GET /api/v1/ecostake/position/:user_id`
- **EcoGem (EGM)**: `GET /api/v1/ecogem/balance/:user_id`
- **GST Token**: `GET /api/v1/gst/balance/:address/:token_id`

## 📝 **EXEMPLOS DE USO**

### **Obter Perfil ESG:**
```bash
curl -X GET "https://api.ecosystem-degov.com/api/v1/esg/unified-profile/user123"   -H "Authorization: Bearer <token>"
```

### **Transferir Tokens:**
```bash
curl -X POST "https://api.ecosystem-degov.com/api/v1/esg/transfer-unified"   -H "Content-Type: application/json"   -H "Authorization: Bearer <token>"   -d '{
    "from_platform": "guardrive",
    "to_platform": "guardflow", 
    "amount": 1000
  }'
```

---
**📚 API Documentation - ESG Token Ecosystem**
