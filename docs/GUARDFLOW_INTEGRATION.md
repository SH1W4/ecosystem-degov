# 🔗 GuardFlow Integration Guide

**Ecosystem Degov ↔️ GuardFlow Integration**

This document explains how the [GuardFlow](https://github.com/guardflow-core) MVP integrates with the Ecosystem Degov token system.

---

## 🎯 Overview

**GuardFlow** is the first MVP application built on top of the Ecosystem Degov token infrastructure. It demonstrates how external applications can:
- Mint and distribute ecosystem tokens (AET, ECR)
- Verify on-chain transactions
- Reward users for ESG-compliant behavior

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    GuardFlow MVP                        │
│  (https://github.com/guardflow-core)                    │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │   Frontend   │  │   Backend    │  │  AI Scanner  │ │
│  │  React + TS  │  │  Rust + PG   │  │    Python    │ │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘ │
│         │                  │                            │
│         └──────────┬───────┘                            │
│                    │                                    │
└────────────────────┼────────────────────────────────────┘
                     │
                     │ Web3.js / Ethers.js
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Ecosystem Degov Contracts                  │
│  (https://github.com/SH1W4/ecosystem-degov)             │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  TrinityGSTToken (Sepolia)                       │  │
│  │  0xfb927badA2a4cb58026B1b23528A4a42FA035c45      │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  AET Token   │  │  ECR Token   │  │  GST Token   │ │
│  │ (AI Ethics)  │  │(Certificate) │  │(Ecosystem)   │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## 🪙 Token Integration

### AET (AI Ethics Token)

**Use Case**: Reward companies for ethical AI practices

**GuardFlow Implementation**:
```typescript
// frontend/src/services/tokenService.ts
import { ethers } from 'ethers';
import TrinityGSTABI from './abis/TrinityGSTToken.json';

const CONTRACT_ADDRESS = '0xfb927badA2a4cb58026B1b23528A4a42FA035c45';
const SEPOLIA_RPC = 'https://sepolia.infura.io/v3/YOUR_KEY';

export async function mintAETReward(userAddress: string, score: number) {
  const provider = new ethers.providers.JsonRpcProvider(SEPOLIA_RPC);
  const signer = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);
  const contract = new ethers.Contract(CONTRACT_ADDRESS, TrinityGSTABI, signer);

  // Calculate AET reward based on AI ethics score
  const aetAmount = calculateAETReward(score);
  
  // Mint AET tokens
  const tx = await contract.mint(userAddress, aetAmount);
  await tx.wait();
  
  return tx.hash;
}
```

### ECR (EcoCertificate)

**Use Case**: Issue NFT certificates for compliance milestones

**GuardFlow Implementation**:
```typescript
// Issue certificate when company reaches 90+ ESG score
export async function issueCertificate(companyId: string, esgScore: number) {
  if (esgScore >= 90) {
    const tx = await contract.issueECR(companyId, {
      score: esgScore,
      timestamp: Date.now(),
      auditor: 'GuardFlow AI'
    });
    return tx.hash;
  }
}
```

---

## 🔧 Setup Instructions

### 1. Clone Both Repositories

```bash
# Ecosystem Degov (Smart Contracts)
git clone https://github.com/SH1W4/ecosystem-degov.git
cd ecosystem-degov
npm install

# GuardFlow (MVP Application)
git clone https://github.com/guardflow-core/guardflow.git
cd guardflow
npm install
```

### 2. Configure Environment Variables

**In GuardFlow `.env`**:
```env
# Blockchain Configuration
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
PRIVATE_KEY=your_deployer_private_key

# Ecosystem Degov Contracts
TRINITY_GST_ADDRESS=0xfb927badA2a4cb58026B1b23528A4a42FA035c45
AET_TOKEN_ADDRESS=0x... # Deploy AET contract
ECR_TOKEN_ADDRESS=0x... # Deploy ECR contract

# Backend
DATABASE_URL=postgresql://user:pass@localhost/guardflow
JWT_SECRET=your_jwt_secret
```

### 3. Deploy Missing Tokens (if needed)

```bash
# In ecosystem-degov directory
npx hardhat run scripts/deploy-aet-token.js --network sepolia
npx hardhat run scripts/deploy-ecr-token.js --network sepolia

# Copy addresses to GuardFlow .env
```

### 4. Run GuardFlow

```bash
# Terminal 1: Frontend
cd guardflow/frontend
npm run dev

# Terminal 2: Backend
cd guardflow/backend
cargo run

# Terminal 3: AI Scanner
cd guardflow/ai-scanner
python app.py
```

---

## 📊 Data Flow

### User Completes AI Audit

1. **GuardFlow Frontend**: User uploads AI model
2. **GuardFlow AI Scanner**: Analyzes model for bias
3. **GuardFlow Backend**: Calculates ethics score (0-100)
4. **Ecosystem Degov Contract**: Mints AET tokens based on score
5. **GuardFlow Frontend**: Displays token balance and transaction

### Company Reaches Milestone

1. **GuardFlow Backend**: Detects ESG score ≥ 90
2. **Ecosystem Degov Contract**: Mints ECR NFT certificate
3. **GuardFlow Frontend**: Shows certificate in dashboard
4. **IPFS**: Stores certificate metadata

---

## 🎯 Integration Checklist

### Phase 1: Basic Integration (Week 1)
- [ ] Connect GuardFlow to Sepolia testnet
- [ ] Implement AET minting logic
- [ ] Test token transfers
- [ ] Display token balances in UI

### Phase 2: Advanced Features (Week 2)
- [ ] Deploy AET and ECR contracts
- [ ] Implement ECR NFT minting
- [ ] Add transaction history
- [ ] Create token analytics dashboard

### Phase 3: Production Ready (Week 3)
- [ ] Security audit
- [ ] Gas optimization
- [ ] Error handling
- [ ] User documentation

---

## 🔐 Security Considerations

1. **Private Key Management**
   - Never commit `.env` to git
   - Use environment variables in production
   - Consider using AWS Secrets Manager

2. **Rate Limiting**
   - Limit token minting to prevent abuse
   - Implement cooldown periods
   - Verify user identity before minting

3. **Smart Contract Security**
   - Only owner can mint tokens
   - Implement pausable functionality
   - Add reentrancy guards

---

## 📚 Resources

- **Ecosystem Degov Repo**: https://github.com/SH1W4/ecosystem-degov
- **GuardFlow Repo**: https://github.com/guardflow-core
- **Smart Contract (Sepolia)**: https://sepolia.etherscan.io/address/0xfb927badA2a4cb58026B1b23528A4a42FA035c45
- **Pitch Deck**: [ecosystem-degov/docs/investor/](https://github.com/SH1W4/ecosystem-degov/tree/main/docs/investor)

---

## 🤝 Contributing

Both projects welcome contributions:
- **Ecosystem Degov**: Smart contracts, token logic
- **GuardFlow**: Frontend, backend, AI scanner

---

**Questions?** Open an issue in the respective repository.
