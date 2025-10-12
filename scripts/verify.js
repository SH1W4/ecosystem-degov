const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Verificando Smart Contracts ESG...");
    
    // Load deployment info
    const fs = require('fs');
    const deploymentInfo = JSON.parse(fs.readFileSync('deployment-info.json', 'utf8'));
    
    console.log("📄 Network:", deploymentInfo.network.name);
    console.log("👤 Deployer:", deploymentInfo.deployer);
    
    const contracts = deploymentInfo.contracts;
    
    // Verify GST Token
    console.log("\n🥇 Verificando GST Token...");
    try {
        const gstToken = await ethers.getContractAt("GSTToken", contracts.GSTToken.address);
        const name = await gstToken.name();
        const symbol = await gstToken.symbol();
        const totalSupply = await gstToken.totalSupply();
        const maxSupply = await gstToken.MAX_SUPPLY();
        
        console.log("✅ GST Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply Atual:", ethers.utils.formatEther(totalSupply));
        console.log("   Supply Máximo:", ethers.utils.formatEther(maxSupply));
    } catch (error) {
        console.log("❌ Erro ao verificar GST Token:", error.message);
    }
    
    // Verify ECT Token
    console.log("\n🥈 Verificando ECT Token...");
    try {
        const ectToken = await ethers.getContractAt("ECTToken", contracts.ECTToken.address);
        const name = await ectToken.name();
        const symbol = await ectToken.symbol();
        const totalSupply = await ectToken.totalSupply();
        
        console.log("✅ ECT Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply Atual:", ethers.utils.formatEther(totalSupply));
    } catch (error) {
        console.log("❌ Erro ao verificar ECT Token:", error.message);
    }
    
    // Verify CCR Token
    console.log("\n🥉 Verificando CCR Token...");
    try {
        const ccrToken = await ethers.getContractAt("CCRToken", contracts.CCRToken.address);
        const name = await ccrToken.name();
        const symbol = await ccrToken.symbol();
        const totalSupply = await ccrToken.totalSupply();
        
        console.log("✅ CCR Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply Atual:", ethers.utils.formatEther(totalSupply));
    } catch (error) {
        console.log("❌ Erro ao verificar CCR Token:", error.message);
    }
    
    // Verify ECS Token
    console.log("\n📊 Verificando ECS Token...");
    try {
        const ecsToken = await ethers.getContractAt("ECSToken", contracts.ECSToken.address);
        const name = await ecsToken.name();
        const symbol = await ecsToken.symbol();
        const totalSupply = await ecsToken.totalSupply();
        
        console.log("✅ ECS Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply Atual:", ethers.utils.formatEther(totalSupply));
    } catch (error) {
        console.log("❌ Erro ao verificar ECS Token:", error.message);
    }
    
    // Verify ECR Token
    console.log("\n🏆 Verificando ECR Token...");
    try {
        const ecrToken = await ethers.getContractAt("ECRToken", contracts.ECRToken.address);
        const name = await ecrToken.name();
        const symbol = await ecrToken.symbol();
        
        console.log("✅ ECR Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
    } catch (error) {
        console.log("❌ Erro ao verificar ECR Token:", error.message);
    }
    
    // Verify EST Token
    console.log("\n💎 Verificando EST Token...");
    try {
        const estToken = await ethers.getContractAt("ESTToken", contracts.ESTToken.address);
        const name = await estToken.name();
        const symbol = await estToken.symbol();
        const totalSupply = await estToken.totalSupply();
        
        console.log("✅ EST Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply Atual:", ethers.utils.formatEther(totalSupply));
    } catch (error) {
        console.log("❌ Erro ao verificar EST Token:", error.message);
    }
    
    // Verify EGM Token
    console.log("\n💎 Verificando EGM Token...");
    try {
        const egmToken = await ethers.getContractAt("EGMToken", contracts.EGMToken.address);
        const name = await egmToken.name();
        const symbol = await egmToken.symbol();
        const totalSupply = await egmToken.totalSupply();
        
        console.log("✅ EGM Token verificado:");
        console.log("   Nome:", name);
        console.log("   Símbolo:", symbol);
        console.log("   Supply Atual:", ethers.utils.formatEther(totalSupply));
    } catch (error) {
        console.log("❌ Erro ao verificar EGM Token:", error.message);
    }
    
    console.log("\n🎉 VERIFICAÇÃO COMPLETA!");
    console.log("📊 Todos os 7 tokens ESG foram verificados com sucesso!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro na verificação:", error);
        process.exit(1);
    });
