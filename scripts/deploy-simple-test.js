// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🧪 TESTE SIMPLES - DEPLOY LOCAL");
    console.log("=" * 50);

    try {
        // Verificar rede
        const network = await ethers.provider.getNetwork();
        console.log(`🌐 Rede: ${network.name} (${network.chainId})`);

        // Obter deployer
        const [deployer] = await ethers.getSigners();
        console.log(`👤 Deployer: ${deployer.address}`);

        // Verificar saldo
        const balance = await ethers.provider.getBalance(deployer.address);
        console.log(`💰 Saldo: ${ethers.formatEther(balance)} ETH`);

        console.log("\n🏗️ Deployando GST Token...");

        // Deploy GST Token
        const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
        const gstToken = await GSTToken.deploy();
        await gstToken.waitForDeployment();
        const gstAddress = await gstToken.getAddress();

        console.log(`✅ GST Token: ${gstAddress}`);

        // Testar contrato
        const name = await gstToken.name();
        const symbol = await gstToken.symbol();
        const totalSupply = await gstToken.totalSupply();

        console.log(`📊 Nome: ${name}`);
        console.log(`📊 Símbolo: ${symbol}`);
        console.log(`📊 Total Supply: ${ethers.formatEther(totalSupply)} tokens`);

        console.log("\n🎉 TESTE CONCLUÍDO COM SUCESSO!");
        console.log("🧠 Trinity AI: Dados coletados para aprendizado!");

    } catch (error) {
        console.error("❌ Erro:", error.message);
        process.exit(1);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
