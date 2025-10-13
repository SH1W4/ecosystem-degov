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
    const gstToken = await GSTToken.deploy();
    await gstToken.waitForDeployment();
    console.log(`✅ GST Token: ${await gstToken.getAddress()}`);

    // 2. Deploy AET Token
    console.log("\n🤖 Deployando SimpleAETToken...");
    const AETToken = await ethers.getContractFactory("SimpleAETToken");
    const aetToken = await AETToken.deploy();
    await aetToken.waitForDeployment();
    console.log(`✅ AET Token: ${await aetToken.getAddress()}`);

    // Resumo
    console.log("\n🎉 DEPLOY CONCLUÍDO!");
    console.log("=" * 50);
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log("\n📋 Contratos:");
    console.log(`🥇 GST: ${await gstToken.getAddress()}`);
    console.log(`🤖 AET: ${await aetToken.getAddress()}`);
    
    console.log("\n💡 Para testar:");
    console.log(`npx hardhat console --network localhost`);
    console.log(`const GST = await ethers.getContractAt("SimpleGSTToken", "${await gstToken.getAddress()}")`);
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
