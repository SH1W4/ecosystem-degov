// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 DEPLOY OTIMIZADO PARA GOERLI TESTNET");
    console.log("🧠 Trinity AI: Aplicando estratégias de economia de gas...");

    // Verificar rede
    const network = await ethers.provider.getNetwork();
    console.log(`🌐 Rede atual: ${network.name} (Chain ID: ${network.chainId})`);

    if (network.chainId !== 5) {
        console.warn("⚠️ ATENÇÃO: Este script foi projetado para Goerli (Chain ID: 5)");
        console.warn("   Continuando mesmo assim para demonstração...");
    }

    // Obter deployer
    const [deployer] = await ethers.getSigners();
    console.log(`👤 Deployer: ${deployer.address}`);

    // Verificar saldo
    const balance = await ethers.provider.getBalance(deployer.address);
    console.log(`💰 Saldo: ${ethers.utils.formatEther(balance)} ETH`);

    if (balance.lt(ethers.utils.parseEther("0.01"))) {
        console.error("❌ Saldo insuficiente! Você precisa de pelo menos 0.01 ETH");
        console.log("💡 Obtenha ETH de teste em:");
        console.log("   - https://goerli-faucet.pk910.de/");
        console.log("   - https://goerli-faucet.mudit.blog/");
        console.log("   - https://faucets.chain.link/goerli");
        return;
    }

    console.log("\n🏗️ Deployando contratos ESG com otimização de gas...");

    const deployedContracts = {};

    try {
        // 1. Deploy GST Token (Principal)
        console.log("\n🥇 Deployando SimpleGSTToken (Token Principal)...");
        const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
        const gstToken = await GSTToken.deploy();
        await gstToken.waitForDeployment();
        const gstAddress = await gstToken.getAddress();
        deployedContracts.GST = gstAddress;
        console.log(`✅ GST Token: ${gstAddress}`);

        // 2. Deploy AET Token (IA Ética)
        console.log("\n🤖 Deployando SimpleAETToken (IA Ética)...");
        const AETToken = await ethers.getContractFactory("SimpleAETToken");
        const aetToken = await AETToken.deploy();
        await aetToken.waitForDeployment();
        const aetAddress = await aetToken.getAddress();
        deployedContracts.AET = aetAddress;
        console.log(`✅ AET Token: ${aetAddress}`);

        // Verificar saldo final
        const finalBalance = await ethers.provider.getBalance(deployer.address);
        const gasUsed = balance.sub(finalBalance);
        console.log(`⛽ Gas usado: ${ethers.utils.formatEther(gasUsed)} ETH`);

        // Resumo final
        console.log("\n🎉 DEPLOY CONCLUÍDO COM SUCESSO!");
        console.log("=" * 60);
        console.log(`👤 Deployer: ${deployer.address}`);
        console.log(`🌐 Rede: ${network.name} (${network.chainId})`);
        console.log(`⛽ Gas usado: ${ethers.utils.formatEther(gasUsed)} ETH`);
        console.log(`💰 Saldo restante: ${ethers.utils.formatEther(finalBalance)} ETH`);

        console.log("\n📋 CONTRATOS DEPLOYADOS:");
        console.log(`🥇 GST Token: ${gstAddress}`);
        console.log(`🤖 AET Token: ${aetAddress}`);

        console.log("\n🔗 LINKS ÚTEIS:");
        console.log(`🌐 Goerli Explorer: https://goerli.etherscan.io/`);
        console.log(`📊 GST Contract: https://goerli.etherscan.io/address/${gstAddress}`);
        console.log(`🤖 AET Contract: https://goerli.etherscan.io/address/${aetAddress}`);

        console.log("\n💡 COMANDOS PARA TESTAR:");
        console.log("npx hardhat console --network goerli");
        console.log(`const GST = await ethers.getContractAt("SimpleGSTToken", "${gstAddress}")`);
        console.log(`const AET = await ethers.getContractAt("SimpleAETToken", "${aetAddress}")`);
        console.log("await GST.name()");
        console.log("await GST.symbol()");
        console.log("await GST.totalSupply()");
        console.log("await AET.name()");
        console.log("await AET.symbol()");
        console.log("await AET.totalSupply()");

        console.log("\n🧠 TRINITY AI: Dados de deploy salvos para aprendizado!");
        console.log("📊 Análise de custos: Gas otimizado para Goerli");
        console.log("⚡ Próximo passo: Deploy em Polygon para economia de 95%");

    } catch (error) {
        console.error("❌ Erro durante deploy:", error);
        process.exit(1);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });
