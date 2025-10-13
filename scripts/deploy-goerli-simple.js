// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 Iniciando deploy SIMPLES do Ecosystem Degov na Goerli Testnet...");
    
    // Verificar se estamos na rede correta
    const network = await ethers.provider.getNetwork();
    console.log(`📡 Rede atual: ${network.name} (Chain ID: ${network.chainId})`);
    
    if (network.chainId !== 5) {
        throw new Error("❌ Este script deve ser executado na Goerli Testnet (Chain ID: 5)");
    }

    // Obter o deployer
    const [deployer] = await ethers.getSigners();
    console.log(`👤 Deployer: ${deployer.address}`);
    
    // Verificar saldo
    const balance = await deployer.getBalance();
    console.log(`💰 Saldo: ${ethers.utils.formatEther(balance)} ETH`);
    
    if (balance.lt(ethers.utils.parseEther("0.01"))) {
        throw new Error("❌ Saldo insuficiente. Precisa de pelo menos 0.01 ETH na Goerli");
    }

    console.log("\n🏗️ Deployando contratos SIMPLES...");

    // 1. Deploy GST Token (Principal) - SIMPLES
    console.log("\n🥇 Deployando GST Token (Simples)...");
    const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
    const gstToken = await GSTToken.deploy(
        "Green Sustainability Token",
        "GST",
        ethers.utils.parseEther("1000000000"), // 1 bilhão de tokens
        deployer.address
    );
    await gstToken.deployed();
    console.log(`✅ GST Token deployado em: ${gstToken.address}`);

    // 2. Deploy AET Token (AI Ethics) - SIMPLES
    console.log("\n🤖 Deployando AET Token (Simples)...");
    const AETToken = await ethers.getContractFactory("SimpleAETToken");
    const aetToken = await AETToken.deploy(
        "AI Ethics Token",
        "AET",
        ethers.utils.parseEther("500000000"), // 500 milhões de tokens
        deployer.address
    );
    await aetToken.deployed();
    console.log(`✅ AET Token deployado em: ${aetToken.address}`);

    // Aguardar confirmações
    console.log("\n⏳ Aguardando confirmações...");
    await gstToken.deployTransaction.wait(2);
    await aetToken.deployTransaction.wait(2);

    // Salvar informações de deploy
    const deploymentInfo = {
        network: "goerli",
        chainId: 5,
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

    // Salvar arquivo de deploy
    const fs = require('fs');
    const path = require('path');
    const deployDir = path.join(__dirname, '..', 'deployments', 'testnet');
    
    if (!fs.existsSync(deployDir)) {
        fs.mkdirSync(deployDir, { recursive: true });
    }
    
    const deployFile = path.join(deployDir, 'goerli-simple-deployment.json');
    fs.writeFileSync(deployFile, JSON.stringify(deploymentInfo, null, 2));
    
    console.log(`\n📄 Informações de deploy salvas em: ${deployFile}`);

    // Resumo final
    console.log("\n🎉 DEPLOY SIMPLES CONCLUÍDO COM SUCESSO!");
    console.log("=" * 50);
    console.log(`🌐 Rede: Goerli Testnet`);
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log(`⏰ Timestamp: ${deploymentInfo.timestamp}`);
    console.log("\n📋 Contratos Deployados:");
    console.log(`🥇 GST Token: ${gstToken.address}`);
    console.log(`🤖 AET Token: ${aetToken.address}`);
    
    console.log("\n🔗 Links para verificação:");
    console.log(`GST: https://goerli.etherscan.io/address/${gstToken.address}`);
    console.log(`AET: https://goerli.etherscan.io/address/${aetToken.address}`);
    
    console.log("\n🚀 Próximos passos:");
    console.log("1. Verificar contratos no Etherscan");
    console.log("2. Testar funcionalidades básicas");
    console.log("3. Integrar com frontend");
    console.log("4. Deploy dos demais tokens");
    
    console.log("\n💡 Comandos para testar:");
    console.log(`npx hardhat console --network goerli`);
    console.log(`const GST = await ethers.getContractAt("SimpleGSTToken", "${gstToken.address}")`);
    console.log(`await GST.name()`);
    console.log(`await GST.symbol()`);
    console.log(`await GST.totalSupply()`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro durante o deploy:", error);
        process.exit(1);
    });
