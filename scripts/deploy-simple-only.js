// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 Deployando apenas contratos SIMPLES na Goerli...");
    
    // Verificar rede
    const network = await ethers.provider.getNetwork();
    console.log(`📡 Rede: ${network.name} (Chain ID: ${network.chainId})`);
    
    if (network.chainId !== 5) {
        console.log("⚠️  ATENÇÃO: Este script foi projetado para Goerli (Chain ID: 5)");
        console.log("   Continuando mesmo assim para demonstração...");
    }

    // Obter deployer
    const [deployer] = await ethers.getSigners();
    console.log(`👤 Deployer: ${deployer.address}`);
    
    // Verificar saldo
    const balance = await ethers.provider.getBalance(deployer.address);
    console.log(`💰 Saldo: ${ethers.utils.formatEther(balance)} ETH`);

    console.log("\n🏗️ Deployando contratos SIMPLES...");

    try {
        // 1. Deploy GST Token (Simples)
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

        // 2. Deploy AET Token (Simples)
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

        // Aguardar confirmações
        console.log("\n⏳ Aguardando confirmações...");
        await gstToken.deployTransaction.wait(1);
        await aetToken.deployTransaction.wait(1);

        // Salvar informações
        const deploymentInfo = {
            network: network.name,
            chainId: network.chainId,
            deployer: deployer.address,
            timestamp: new Date().toISOString(),
            contracts: {
                GST: {
                    address: gstToken.address,
                    name: "Green Sustainability Token",
                    symbol: "GST",
                    totalSupply: "1000000000",
                    transactionHash: gstToken.deployTransaction.hash
                },
                AET: {
                    address: aetToken.address,
                    name: "AI Ethics Token",
                    symbol: "AET",
                    totalSupply: "500000000",
                    transactionHash: aetToken.deployTransaction.hash
                }
            }
        };

        // Salvar arquivo
        const fs = require('fs');
        const path = require('path');
        const deployDir = path.join(__dirname, '..', 'deployments', 'testnet');
        
        if (!fs.existsSync(deployDir)) {
            fs.mkdirSync(deployDir, { recursive: true });
        }
        
        const deployFile = path.join(deployDir, 'simple-deployment.json');
        fs.writeFileSync(deployFile, JSON.stringify(deploymentInfo, null, 2));
        
        console.log(`\n📄 Deploy salvo em: ${deployFile}`);

        // Resumo
        console.log("\n🎉 DEPLOY SIMPLES CONCLUÍDO!");
        console.log("=" * 50);
        console.log(`🌐 Rede: ${network.name}`);
        console.log(`👤 Deployer: ${deployer.address}`);
        console.log(`⏰ Timestamp: ${deploymentInfo.timestamp}`);
        console.log("\n📋 Contratos:");
        console.log(`🥇 GST: ${gstToken.address}`);
        console.log(`🤖 AET: ${aetToken.address}`);
        
        if (network.chainId === 5) {
            console.log("\n🔗 Etherscan Goerli:");
            console.log(`GST: https://goerli.etherscan.io/address/${gstToken.address}`);
            console.log(`AET: https://goerli.etherscan.io/address/${aetToken.address}`);
        }
        
        console.log("\n💡 Para testar:");
        console.log(`npx hardhat console --network ${network.name}`);
        console.log(`const GST = await ethers.getContractAt("SimpleGSTToken", "${gstToken.address}")`);
        console.log(`await GST.name()`);

    } catch (error) {
        console.error("❌ Erro durante deploy:", error.message);
        
        // Tentar deploy individual
        console.log("\n🔄 Tentando deploy individual...");
        
        try {
            console.log("\n🥇 Tentando apenas GST Token...");
            const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
            const gstToken = await GSTToken.deploy(
                "Green Sustainability Token",
                "GST",
                ethers.utils.parseEther("1000000000"),
                deployer.address
            );
            await gstToken.deployed();
            console.log(`✅ GST Token deployado: ${gstToken.address}`);
            
        } catch (gstError) {
            console.error("❌ Erro no GST Token:", gstError.message);
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro fatal:", error);
        process.exit(1);
    });
