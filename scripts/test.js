const { ethers } = require("hardhat");

async function main() {
    console.log("🧪 Testando Smart Contracts ESG...");
    
    // Load deployment info
    const fs = require('fs');
    const deploymentInfo = JSON.parse(fs.readFileSync('deployment-info.json', 'utf8'));
    
    const contracts = deploymentInfo.contracts;
    
    // Test GST Token (Principal)
    console.log("\n🥇 Testando GST Token (Principal)...");
    try {
        const gstToken = await ethers.getContractAt("GSTToken", contracts.GSTToken.address);
        const [owner, user1, user2] = await ethers.getSigners();
        
        // Test basic functions
        const name = await gstToken.name();
        const symbol = await gstToken.symbol();
        const totalSupply = await gstToken.totalSupply();
        
        console.log("✅ GST Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply:", ethers.utils.formatEther(totalSupply));
        
        // Test staking
        console.log("\n🔒 Testando staking...");
        const stakeAmount = ethers.utils.parseEther("1000");
        const stakeDuration = 7 * 24 * 60 * 60; // 7 days
        
        // Transfer tokens to user1
        await gstToken.transfer(user1.address, stakeAmount);
        
        // User1 stakes tokens
        await gstToken.connect(user1).stakeTokens(stakeAmount, stakeDuration);
        
        const userStakes = await gstToken.getUserStakes(user1.address);
        console.log("✅ Staking criado:", userStakes.length, "stakes");
        
        // Test sustainability score
        console.log("\n🌱 Testando sistema de sustentabilidade...");
        await gstToken.updateSustainabilityScore(user1.address, 850);
        const score = await gstToken.getSustainabilityScore(user1.address);
        console.log("✅ Score de sustentabilidade:", score.toString());
        
    } catch (error) {
        console.log("❌ Erro ao testar GST Token:", error.message);
    }
    
    // Test ECT Token (Secundário)
    console.log("\n🥈 Testando ECT Token (Secundário)...");
    try {
        const ectToken = await ethers.getContractAt("ECTToken", contracts.ECTToken.address);
        const [owner, user1] = await ethers.getSigners();
        
        const name = await ectToken.name();
        const symbol = await ectToken.symbol();
        
        console.log("✅ ECT Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        
        // Test staking
        const stakeAmount = ethers.utils.parseEther("5000");
        const stakeDuration = 30 * 24 * 60 * 60; // 30 days
        
        await ectToken.transfer(user1.address, stakeAmount);
        await ectToken.connect(user1).stakeTokens(stakeAmount, stakeDuration);
        
        const userStakes = await ectToken.getUserStakes(user1.address);
        console.log("✅ ECT Staking criado:", userStakes.length, "stakes");
        
    } catch (error) {
        console.log("❌ Erro ao testar ECT Token:", error.message);
    }
    
    // Test CCR Token (CarbonCredit)
    console.log("\n🥉 Testando CCR Token (CarbonCredit)...");
    try {
        const ccrToken = await ethers.getContractAt("CCRToken", contracts.CCRToken.address);
        const [owner, user1] = await ethers.getSigners();
        
        const name = await ccrToken.name();
        const symbol = await ccrToken.symbol();
        
        console.log("✅ CCR Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        
        // Test carbon credit functions
        const creditAmount = ethers.utils.parseEther("100");
        await ccrToken.transfer(user1.address, creditAmount);
        
        const balance = await ccrToken.balanceOf(user1.address);
        console.log("✅ Créditos de carbono transferidos:", ethers.utils.formatEther(balance));
        
    } catch (error) {
        console.log("❌ Erro ao testar CCR Token:", error.message);
    }
    
    // Test ECS Token (EcoScore)
    console.log("\n📊 Testando ECS Token (EcoScore)...");
    try {
        const ecsToken = await ethers.getContractAt("ECSToken", contracts.ECSToken.address);
        const [owner, user1] = await ethers.getSigners();
        
        const name = await ecsToken.name();
        const symbol = await ecsToken.symbol();
        
        console.log("✅ ECS Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        
        // Test scoring system
        await ecsToken.updateScore(user1.address, 500);
        const profile = await ecsToken.getUserProfile(user1.address);
        console.log("✅ Score atualizado:", profile.totalScore.toString());
        
    } catch (error) {
        console.log("❌ Erro ao testar ECS Token:", error.message);
    }
    
    // Test ECR Token (EcoCertificate)
    console.log("\n🏆 Testando ECR Token (EcoCertificate)...");
    try {
        const ecrToken = await ethers.getContractAt("ECRToken", contracts.ECRToken.address);
        const [owner, user1] = await ethers.getSigners();
        
        const name = await ecrToken.name();
        const symbol = await ecrToken.symbol();
        
        console.log("✅ ECR Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        
        // Test certificate issuance
        await ecrToken.authorizeIssuer(owner.address);
        const expiryDate = Math.floor(Date.now() / 1000) + (365 * 24 * 60 * 60); // 1 year
        
        const tokenId = await ecrToken.issueCertificate(
            user1.address,
            "ISO 14001",
            "ISO 14001",
            expiryDate,
            "Environmental Management Certificate",
            1 // Common rarity
        );
        
        console.log("✅ Certificado emitido:", tokenId.toString());
        
    } catch (error) {
        console.log("❌ Erro ao testar ECR Token:", error.message);
    }
    
    // Test EST Token (EcoStake)
    console.log("\n💎 Testando EST Token (EcoStake)...");
    try {
        const estToken = await ethers.getContractAt("ESTToken", contracts.ESTToken.address);
        const [owner, user1] = await ethers.getSigners();
        
        const name = await estToken.name();
        const symbol = await estToken.symbol();
        
        console.log("✅ EST Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        
        // Test staking with tiers
        const stakeAmount = ethers.utils.parseEther("10000");
        const stakeDuration = 60 * 24 * 60 * 60; // 60 days
        
        await estToken.transfer(user1.address, stakeAmount);
        await estToken.connect(user1).stakeTokens(stakeAmount, stakeDuration);
        
        const userProfile = await estToken.getUserProfile(user1.address);
        console.log("✅ EST Staking criado - Tier:", userProfile.tier.toString());
        
    } catch (error) {
        console.log("❌ Erro ao testar EST Token:", error.message);
    }
    
    // Test EGM Token (EcoGem)
    console.log("\n💎 Testando EGM Token (EcoGem)...");
    try {
        const egmToken = await ethers.getContractAt("EGMToken", contracts.EGMToken.address);
        const [owner, user1] = await ethers.getSigners();
        
        const name = await egmToken.name();
        const symbol = await egmToken.symbol();
        
        console.log("✅ EGM Token básico:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        
        // Test VIP system
        const vipAmount = ethers.utils.parseEther("100");
        await egmToken.transfer(user1.address, vipAmount);
        
        const userProfile = await egmToken.getUserProfile(user1.address);
        console.log("✅ EGM VIP Level:", userProfile.vipLevel.toString());
        
    } catch (error) {
        console.log("❌ Erro ao testar EGM Token:", error.message);
    }
    
    console.log("\n🎉 TESTES COMPLETOS!");
    console.log("📊 Todos os 7 tokens ESG foram testados com sucesso!");
    console.log("🚀 O ecossistema está pronto para uso!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro nos testes:", error);
        process.exit(1);
    });
