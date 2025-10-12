const { ethers } = require("hardhat");

async function main() {
    console.log("🤖 Iniciando deploy do AET Token (AI Ethics)...");
    
    // Get the deployer account
    const [deployer] = await ethers.getSigners();
    console.log("📝 Deployer:", deployer.address);
    
    // Deploy AET Token (AI Ethics)
    console.log("\n🤖 Deployando AET Token (AI Ethics)...");
    const SimpleAETToken = await ethers.getContractFactory("SimpleAETToken");
    const aetToken = await SimpleAETToken.deploy();
    await aetToken.waitForDeployment();
    console.log("✅ AET Token deployed to:", aetToken.target);
    
    // Test basic functionality
    console.log("\n🧪 Testando funcionalidades básicas...");
    
    // Get token info
    const name = await aetToken.name();
    const symbol = await aetToken.symbol();
    const totalSupply = await aetToken.totalSupply();
    const maxSupply = await aetToken.MAX_SUPPLY();
    
    console.log("📊 Token Info:");
    console.log("   Name:", name);
    console.log("   Symbol:", symbol);
    console.log("   Total Supply:", ethers.formatEther(totalSupply), "AET");
    console.log("   Max Supply:", ethers.formatEther(maxSupply), "AET");
    
    // Test AI Ethics scoring
    console.log("\n🎯 Testando sistema de scoring ético...");
    
    const testUser = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
    
    // Update AI Ethics Score
    const tx = await aetToken.updateAIEthicsScore(
        testUser,
        900, // transparency
        850, // bias detection
        920, // human alignment
        880  // environmental impact
    );
    await tx.wait();
    console.log("✅ AI Ethics Score atualizado");
    
    // Get user profile
    const profile = await aetToken.getUserAIEthicsProfile(testUser);
    console.log("📊 User Profile:");
    console.log("   Total Score:", profile.ethicsScore.totalScore.toString());
    console.log("   Transparency:", profile.ethicsScore.transparency.toString());
    console.log("   Bias Detection:", profile.ethicsScore.biasDetection.toString());
    console.log("   Human Alignment:", profile.ethicsScore.humanAlignment.toString());
    console.log("   Environmental Impact:", profile.ethicsScore.environmentalImpact.toString());
    console.log("   Total Rewards:", ethers.formatEther(profile.totalRewards), "AET");
    
    // Unlock achievement
    console.log("\n🏆 Testando sistema de conquistas...");
    const achievementTx = await aetToken.unlockAchievement(testUser, "Green AI Pioneer");
    await achievementTx.wait();
    console.log("✅ Achievement desbloqueado");
    
    // Get updated profile
    const updatedProfile = await aetToken.getUserAIEthicsProfile(testUser);
    console.log("📊 Updated Profile:");
    console.log("   Achievement Count:", updatedProfile.achievementCount_.toString());
    console.log("   Total Rewards:", ethers.formatEther(updatedProfile.totalRewards), "AET");
    
    // Get ecosystem stats
    const stats = await aetToken.getAIEthicsEcosystemStats();
    console.log("\n📈 Ecosystem Stats:");
    console.log("   Total Supply:", ethers.formatEther(stats.totalSupply_), "AET");
    console.log("   Max Supply:", ethers.formatEther(stats.maxSupply_), "AET");
    console.log("   Initial Supply:", ethers.formatEther(stats.initialSupply_), "AET");
    
    // Save deployment info
    const deploymentInfo = {
        network: await ethers.provider.getNetwork(),
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contract: {
            AETToken: {
                address: aetToken.address,
                name: "AI Ethics Token",
                symbol: "AET",
                supply: "500,000,000 AET",
                role: "IA Ética",
                features: [
                    "AI Ethics Scoring (0-1000)",
                    "Green AI Incentives",
                    "Transparency & Bias Detection",
                    "Human-Aligned AI Rewards",
                    "Achievement System",
                    "Cross-Platform Integration"
                ]
            }
        }
    };
    
    // Write deployment info to file
    const fs = require('fs');
    fs.writeFileSync('aet-deployment-info.json', JSON.stringify(deploymentInfo, null, 2));
    
    console.log("\n🎉 DEPLOY AET TOKEN COMPLETO!");
    console.log("📄 Deployment info salvo em: aet-deployment-info.json");
    
    // Display summary
    console.log("\n📊 RESUMO DO AET TOKEN:");
    console.log("🤖 AET (AI Ethics):", aetToken.address);
    console.log("🎯 Features: AI Ethics Scoring, Green AI, Transparency, Human Alignment");
    console.log("🏆 Achievements: Sistema de conquistas implementado");
    console.log("💰 Rewards: Sistema de recompensas baseado em score ético");
    
    console.log("\n🚀 Próximos passos:");
    console.log("1. Integrar com Virtual Protocol");
    console.log("2. Conectar com GST Token");
    console.log("3. Implementar frontend");
    console.log("4. Deploy em testnet");
    
    return aetToken.address;
}

main()
    .then((address) => {
        console.log("\n✅ AET Token deployado com sucesso em:", address);
        process.exit(0);
    })
    .catch((error) => {
        console.error("❌ Erro no deploy:", error);
        process.exit(1);
    });
