const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 Iniciando deploy dos Smart Contracts ESG (Versão Simplificada)...");
    
    // Get the deployer account
    const [deployer] = await ethers.getSigners();
    console.log("📝 Deployer:", deployer.address);
    console.log("💰 Balance:", ethers.formatEther(await deployer.provider.getBalance(deployer.address)), "ETH");
    
    // Deploy GST Token (Principal)
    console.log("\n🥇 Deployando GST Token (Principal)...");
    const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
    const gstToken = await GSTToken.deploy();
    await gstToken.waitForDeployment();
    console.log("✅ GST Token deployed to:", await gstToken.getAddress());
    
    // Test basic functions
    console.log("\n🧪 Testando funcionalidades básicas...");
    
    // Test token info
    const name = await gstToken.name();
    const symbol = await gstToken.symbol();
    const totalSupply = await gstToken.totalSupply();
    const maxSupply = await gstToken.MAX_SUPPLY();
    
    console.log("📊 Token Info:");
    console.log("   Nome:", name);
    console.log("   Símbolo:", symbol);
    console.log("   Supply Atual:", ethers.formatEther(totalSupply));
    console.log("   Supply Máximo:", ethers.formatEther(maxSupply));
    
    // Test staking
    console.log("\n🔒 Testando sistema de staking...");
    const stakeAmount = ethers.parseEther("1000");
    const stakeDuration = 7 * 24 * 60 * 60; // 7 days
    
    // Create a test user
    const [owner, user1] = await ethers.getSigners();
    
    // Transfer tokens to user1
    await gstToken.transfer(user1.address, stakeAmount);
    console.log("✅ Tokens transferidos para user1");
    
    // User1 stakes tokens
    await gstToken.connect(user1).stakeTokens(stakeAmount, stakeDuration);
    console.log("✅ Staking criado com sucesso");
    
    // Check user profile
    const userProfile = await gstToken.getUserProfile(user1.address);
    console.log("📊 Perfil do usuário:");
    console.log("   Balance:", ethers.formatEther(userProfile.balance));
    console.log("   Staked:", ethers.formatEther(userProfile.staked));
    console.log("   Sustainability Score:", userProfile.sustainabilityScore.toString());
    console.log("   Pending Rewards:", ethers.formatEther(userProfile.pendingRewards));
    console.log("   Total Stakes:", userProfile.totalStakes.toString());
    
    // Test sustainability score
    console.log("\n🌱 Testando sistema de sustentabilidade...");
    await gstToken.updateSustainabilityScore(user1.address, 850);
    const score = await gstToken.getSustainabilityScore(user1.address);
    console.log("✅ Score de sustentabilidade atualizado:", score.toString());
    
    // Get ecosystem stats
    const stats = await gstToken.getEcosystemStats();
    console.log("\n📊 Estatísticas do ecossistema:");
    console.log("   Total Supply:", ethers.formatEther(stats.totalSupply_));
    console.log("   Total Staked:", ethers.formatEther(stats.totalStaked_));
    console.log("   Max Supply:", ethers.formatEther(stats.maxSupply_));
    console.log("   Initial Supply:", ethers.formatEther(stats.initialSupply_));
    
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
            }
        }
    };
    
    // Write deployment info to file
    const fs = require('fs');
    fs.writeFileSync('simple-deployment-info.json', JSON.stringify(deploymentInfo, null, 2));
    
    console.log("\n🎉 DEPLOY SIMPLIFICADO COMPLETO!");
    console.log("📄 Deployment info salvo em: simple-deployment-info.json");
    
    // Display summary
    console.log("\n📊 RESUMO DO ECOSSISTEMA ESG:");
    console.log("🥇 GST (Principal):", gstToken.address);
    
    console.log("\n🚀 Próximos passos:");
    console.log("1. Verificar contrato no explorer");
    console.log("2. Testar funcionalidades completas");
    console.log("3. Deploy dos outros tokens");
    console.log("4. Deploy em mainnet");
    
    console.log("\n✅ O GST Token está pronto para uso em testnet!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro no deploy:", error);
        process.exit(1);
    });
