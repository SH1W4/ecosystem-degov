// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 Deployando contratos SIMPLES...");
    
    // Obter deployer
    const [deployer] = await ethers.getSigners();
    console.log(`👤 Deployer: ${deployer.address}`);

    console.log("\n🏗️ Deployando contratos...");

    // 1. Deploy GST Token
    console.log("\n🥇 Deployando SimpleGSTToken...");
    const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
    const gstToken = await GSTToken.deploy(
        "Green Sustainability Token",
        "GST",
        ethers.utils.parseEther("1000000000"), // 1 bilhão
        deployer.address
    );
    await gstToken.deployed();
    console.log(`✅ GST Token: ${gstToken.address}`);

    // 2. Deploy AET Token
    console.log("\n🤖 Deployando SimpleAETToken...");
    const AETToken = await ethers.getContractFactory("SimpleAETToken");
    const aetToken = await AETToken.deploy(
        "AI Ethics Token",
        "AET",
        ethers.utils.parseEther("500000000"), // 500 milhões
        deployer.address
    );
    await aetToken.deployed();
    console.log(`✅ AET Token: ${aetToken.address}`);

    // Resumo
    console.log("\n🎉 DEPLOY CONCLUÍDO!");
    console.log("=" * 50);
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log("\n📋 Contratos:");
    console.log(`🥇 GST: ${gstToken.address}`);
    console.log(`🤖 AET: ${aetToken.address}`);
    
    console.log("\n💡 Para testar:");
    console.log(`npx hardhat console --network localhost`);
    console.log(`const GST = await ethers.getContractAt("SimpleGSTToken", "${gstToken.address}")`);
    console.log(`await GST.name()`);
    console.log(`await GST.symbol()`);
    console.log(`await GST.totalSupply()`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro:", error);
        process.exit(1);
    });
