const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 Iniciando deploy dos Smart Contracts ESG...");
    
    // Get the deployer account
    const [deployer] = await ethers.getSigners();
    console.log("📝 Deployer:", deployer.address);
    console.log("💰 Balance:", ethers.utils.formatEther(await deployer.getBalance()), "ETH");
    
    // Deploy GST Token (Principal)
    console.log("\n🥇 Deployando GST Token (Principal)...");
    const GSTToken = await ethers.getContractFactory("GSTToken");
    const gstToken = await GSTToken.deploy();
    await gstToken.deployed();
    console.log("✅ GST Token deployed to:", gstToken.address);
    
    // Deploy ECT Token (Secundário)
    console.log("\n🥈 Deployando ECT Token (Secundário)...");
    const ECTToken = await ethers.getContractFactory("ECTToken");
    const ectToken = await ECTToken.deploy();
    await ectToken.deployed();
    console.log("✅ ECT Token deployed to:", ectToken.address);
    
    // Deploy CCR Token (CarbonCredit)
    console.log("\n🥉 Deployando CCR Token (CarbonCredit)...");
    const CCRToken = await ethers.getContractFactory("CCRToken");
    const ccrToken = await CCRToken.deploy();
    await ccrToken.deployed();
    console.log("✅ CCR Token deployed to:", ccrToken.address);
    
    // Deploy ECS Token (EcoScore)
    console.log("\n📊 Deployando ECS Token (EcoScore)...");
    const ECSToken = await ethers.getContractFactory("ECSToken");
    const ecsToken = await ECSToken.deploy();
    await ecsToken.deployed();
    console.log("✅ ECS Token deployed to:", ecsToken.address);
    
    // Deploy ECR Token (EcoCertificate)
    console.log("\n🏆 Deployando ECR Token (EcoCertificate)...");
    const ECRToken = await ethers.getContractFactory("ECRToken");
    const ecrToken = await ECRToken.deploy();
    await ecrToken.deployed();
    console.log("✅ ECR Token deployed to:", ecrToken.address);
    
    // Deploy EST Token (EcoStake)
    console.log("\n💎 Deployando EST Token (EcoStake)...");
    const ESTToken = await ethers.getContractFactory("ESTToken");
    const estToken = await ESTToken.deploy();
    await estToken.deployed();
    console.log("✅ EST Token deployed to:", estToken.address);
    
    // Deploy EGM Token (EcoGem)
    console.log("\n💎 Deployando EGM Token (EcoGem)...");
    const EGMToken = await ethers.getContractFactory("EGMToken");
    const egmToken = await EGMToken.deploy();
    await egmToken.deployed();
    console.log("✅ EGM Token deployed to:", egmToken.address);
    
    // Configure integrations
    console.log("\n🔗 Configurando integrações...");
    
    // Set GST token addresses in other tokens
    await ecsToken.setGSTToken(gstToken.address);
    await ecrToken.setGSTToken(gstToken.address);
    await estToken.setGSTToken(gstToken.address);
    await egmToken.setGSTToken(gstToken.address);
    
    console.log("✅ Integrações configuradas");
    
    // Save deployment info
    const deploymentInfo = {
        network: await ethers.provider.getNetwork(),
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            GSTToken: {
                address: gstToken.address,
                name: "Green Sustainability Token",
                symbol: "GST",
                supply: "1,000,000,000 GST",
                role: "Token Principal"
            },
            ECTToken: {
                address: ectToken.address,
                name: "EcoToken",
                symbol: "ECT",
                supply: "10,000,000,000 ECT",
                role: "Token Secundário"
            },
            CCRToken: {
                address: ccrToken.address,
                name: "CarbonCredit Token",
                symbol: "CCR",
                supply: "1,000,000 CCR",
                role: "Créditos de Carbono"
            },
            ECSToken: {
                address: ecsToken.address,
                name: "EcoScore Token",
                symbol: "ECS",
                supply: "100,000,000 ECS",
                role: "Sistema de Pontuação"
            },
            ECRToken: {
                address: ecrToken.address,
                name: "EcoCertificate",
                symbol: "ECR",
                supply: "10,000,000 ECR",
                role: "Certificados NFT"
            },
            ESTToken: {
                address: estToken.address,
                name: "EcoStake Token",
                symbol: "EST",
                supply: "5,000,000,000 EST",
                role: "Staking Avançado"
            },
            EGMToken: {
                address: egmToken.address,
                name: "EcoGem Token",
                symbol: "EGM",
                supply: "1,000,000 EGM",
                role: "Token Premium"
            }
        }
    };
    
    // Write deployment info to file
    const fs = require('fs');
    fs.writeFileSync('deployment-info.json', JSON.stringify(deploymentInfo, null, 2));
    
    console.log("\n🎉 DEPLOY COMPLETO!");
    console.log("📄 Deployment info salvo em: deployment-info.json");
    
    // Display summary
    console.log("\n📊 RESUMO DO ECOSSISTEMA ESG:");
    console.log("🥇 GST (Principal):", gstToken.address);
    console.log("🥈 ECT (Secundário):", ectToken.address);
    console.log("🥉 CCR (Carbono):", ccrToken.address);
    console.log("📊 ECS (Pontuação):", ecsToken.address);
    console.log("🏆 ECR (Certificados):", ecrToken.address);
    console.log("💎 EST (Stake):", estToken.address);
    console.log("💎 EGM (Premium):", egmToken.address);
    
    console.log("\n🚀 Próximos passos:");
    console.log("1. Verificar contratos no explorer");
    console.log("2. Configurar frontend");
    console.log("3. Testar funcionalidades");
    console.log("4. Deploy em mainnet");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro no deploy:", error);
        process.exit(1);
    });
