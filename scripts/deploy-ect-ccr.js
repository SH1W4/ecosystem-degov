const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {
    console.log("🌱 Iniciando deploy dos tokens ECT e CCR...");
    
    // Get the deployer account
    const [deployer] = await ethers.getSigners();
    console.log("📝 Deployer:", deployer.address);
    
    // Deploy ECT Token (EcoToken)
    console.log("\n🌱 Deployando ECT Token (EcoToken)...");
    const ECTToken = await ethers.getContractFactory("ECTToken");
    const ectToken = await ECTToken.deploy();
    await ectToken.waitForDeployment();
    console.log("✅ ECT Token deployed to:", ectToken.target);
    
    // Deploy CCR Token (Carbon Credit)
    console.log("\n🌍 Deployando CCR Token (Carbon Credit)...");
    const CCRToken = await ethers.getContractFactory("CCRToken");
    const ccrToken = await CCRToken.deploy();
    await ccrToken.waitForDeployment();
    console.log("✅ CCR Token deployed to:", ccrToken.target);
    
    // Test basic functionality
    console.log("\n🧪 Testando funcionalidades básicas...");
    
    // Get ECT Token info
    const ectName = await ectToken.name();
    const ectSymbol = await ectToken.symbol();
    const ectTotalSupply = await ectToken.totalSupply();
    const ectMaxSupply = await ectToken.MAX_SUPPLY();
    
    console.log("📊 ECT Token Info:");
    console.log("   Name:", ectName);
    console.log("   Symbol:", ectSymbol);
    console.log("   Total Supply:", ethers.formatEther(ectTotalSupply), "ECT");
    console.log("   Max Supply:", ethers.formatEther(ectMaxSupply), "ECT");
    
    // Get CCR Token info
    const ccrName = await ccrToken.name();
    const ccrSymbol = await ccrToken.symbol();
    const ccrTotalSupply = await ccrToken.totalSupply();
    const ccrMaxSupply = await ccrToken.MAX_SUPPLY();
    
    console.log("📊 CCR Token Info:");
    console.log("   Name:", ccrName);
    console.log("   Symbol:", ccrSymbol);
    console.log("   Total Supply:", ethers.formatEther(ccrTotalSupply), "CCR");
    console.log("   Max Supply:", ethers.formatEther(ccrMaxSupply), "CCR");
    
    // Test ECT ESG scoring
    console.log("\n🎯 Testando sistema ESG do ECT...");
    
    const testUser = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"; // Hardhat's second default account
    
    // Update ESG Score
    const updateESGTx = await ectToken.updateESGScore(testUser, 850, 800, 900, 750);
    await updateESGTx.wait();
    console.log("✅ ESG Score atualizado");
    
    // Get user profile
    const profile = await ectToken.getUserESGProfile(testUser);
    console.log("📊 User ESG Profile:");
    console.log("   Sustainability Score:", profile.sustainabilityScore.toString());
    console.log("   Environmental Impact:", profile.environmentalImpact.toString());
    console.log("   Social Impact:", profile.socialImpact.toString());
    console.log("   Governance Score:", profile.governanceScore.toString());
    console.log("   Total Rewards:", ethers.formatEther(profile.totalRewards), "ECT");
    
    // Unlock achievement
    console.log("\n🏆 Testando sistema de conquistas ECT...");
    const achievementTx = await ectToken.unlockAchievement(testUser, "ESG Pioneer");
    await achievementTx.wait();
    console.log("✅ Achievement ECT desbloqueado");
    
    // Test CCR Carbon Credit
    console.log("\n🌍 Testando sistema de créditos de carbono CCR...");
    
    // Issue a carbon credit
    const issueCreditTx = await ccrToken.issueCarbonCredit(
        "Solar Farm Project",
        "Renewable Energy",
        "Brazil",
        1000, // 1000 tons CO2
        "VCS",
        "ipfs://QmExampleMetadata"
    );
    await issueCreditTx.wait();
    console.log("✅ Carbon Credit emitido");
    
    // Get carbon credit info
    const creditInfo = await ccrToken.getCarbonCredit(1);
    console.log("📊 Carbon Credit Info:");
    console.log("   Project Name:", creditInfo.projectName);
    console.log("   Project Type:", creditInfo.projectType);
    console.log("   Location:", creditInfo.location);
    console.log("   CO2 Equivalent:", creditInfo.co2Equivalent.toString(), "tons");
    console.log("   Verification Standard:", creditInfo.verificationStandard);
    
    // Get ecosystem stats
    const ectStats = await ectToken.getESGEcosystemStats();
    const ccrStats = await ccrToken.getCarbonEcosystemStats();
    
    console.log("\n📈 ECT Ecosystem Stats:");
    console.log("   Total Supply:", ethers.formatEther(ectStats.totalSupply_), "ECT");
    console.log("   Max Supply:", ethers.formatEther(ectStats.maxSupply_), "ECT");
    console.log("   Initial Supply:", ethers.formatEther(ectStats.initialSupply_), "ECT");
    
    console.log("\n📈 CCR Ecosystem Stats:");
    console.log("   Total Supply:", ethers.formatEther(ccrStats.totalSupply_), "CCR");
    console.log("   Max Supply:", ethers.formatEther(ccrStats.maxSupply_), "CCR");
    console.log("   Credits Issued:", ccrStats.totalCreditsIssued_.toString(), "tons CO2");
    console.log("   Credits Retired:", ccrStats.totalCreditsRetired_.toString(), "tons CO2");
    console.log("   Active Credits:", ccrStats.activeCredits_.toString(), "tons CO2");
    
    // Save deployment info
    const deploymentInfo = {
        network: await ethers.provider.getNetwork(),
        deployer: deployer.address,
        ECTToken: {
            address: ectToken.target,
            name: ectName,
            symbol: ectSymbol,
            totalSupply: ethers.formatEther(ectTotalSupply),
            maxSupply: ethers.formatEther(ectMaxSupply),
            initialSupply: ethers.formatEther(await ectToken.INITIAL_SUPPLY()),
            role: "Recompensas ESG"
        },
        CCRToken: {
            address: ccrToken.target,
            name: ccrName,
            symbol: ccrSymbol,
            totalSupply: ethers.formatEther(ccrTotalSupply),
            maxSupply: ethers.formatEther(ccrMaxSupply),
            initialSupply: ethers.formatEther(await ccrToken.INITIAL_SUPPLY()),
            role: "Créditos de Carbono"
        }
    };

    const deploymentInfoPath = 'ect-ccr-deployment-info.json';
    fs.writeFileSync(deploymentInfoPath, JSON.stringify(deploymentInfo, null, 2));
    console.log("\n🎉 DEPLOY ECT + CCR TOKENS COMPLETO!");
    console.log("📄 Deployment info salvo em:", deploymentInfoPath);

    console.log("\n📊 RESUMO DOS TOKENS:");
    console.log("🌱 ECT (EcoToken):", ectToken.target);
    console.log("🌍 CCR (Carbon Credit):", ccrToken.target);
    console.log("🎯 Features: ESG Scoring, Carbon Credits, Achievements");
    console.log("💰 Rewards: Sistema de recompensas ESG implementado");

    console.log("\n🚀 Próximos passos:");
    console.log("1. Integrar com GST Token");
    console.log("2. Conectar com Virtual Protocol");
    console.log("3. Implementar frontend");
    console.log("4. Deploy em testnet");

    console.log("\n✅ ECT + CCR Tokens deployados com sucesso!");
}

main().catch((error) => {
    console.error("❌ Erro no deploy:", error);
    process.exitCode = 1;
});
