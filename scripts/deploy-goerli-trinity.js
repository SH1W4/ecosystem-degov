// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🧠 Deployando Trinity ESG Contract em Goerli Testnet...");
    console.log("💰 CUSTO: GRATUITO (ETH de teste)");

    const [deployer] = await ethers.getSigners();
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log(`💰 Saldo do deployer: ${ethers.formatEther(await ethers.provider.getBalance(deployer.address))} ETH`);

    // Verificar se tem ETH suficiente
    const balance = await ethers.provider.getBalance(deployer.address);
    if (balance < ethers.parseEther("0.01")) {
        console.log("❌ Saldo insuficiente! Obtenha ETH de teste em:");
        console.log("   🔗 https://goerlifaucet.com/");
        console.log("   🔗 https://faucet.quicknode.com/ethereum/goerli");
        console.log("   🔗 https://faucets.chain.link/goerli");
        return;
    }

    // Deploy GST Token primeiro
    console.log("\n🏗️ Deployando GST Token...");
    const GSTToken = await ethers.getContractFactory("SimpleGSTToken");
    const gstToken = await GSTToken.deploy();
    await gstToken.waitForDeployment();
    const gstAddress = await gstToken.getAddress();
    console.log(`✅ GST Token: ${gstAddress}`);

    // Deploy AET Token
    console.log("\n🏗️ Deployando AET Token...");
    const AETToken = await ethers.getContractFactory("SimpleAETToken");
    const aetToken = await AETToken.deploy();
    await aetToken.waitForDeployment();
    const aetAddress = await aetToken.getAddress();
    console.log(`✅ AET Token: ${aetAddress}`);

    // Deploy Trinity ESG Contract
    console.log("\n🏗️ Deployando Trinity ESG Contract...");
    const TrinityESGContract = await ethers.getContractFactory("TrinityESGContract");
    const trinityContract = await TrinityESGContract.deploy(
        gstAddress,
        aetAddress,
        "0x0000000000000000000000000000000000000000" // NFT NFe placeholder
    );
    await trinityContract.waitForDeployment();
    const trinityAddress = await trinityContract.getAddress();
    console.log(`✅ Trinity ESG Contract: ${trinityAddress}`);

    // Verificar configurações
    console.log("\n⚙️ Configurações do contrato:");
    const baseRewardRate = await trinityContract.baseRewardRate();
    const bonusMultiplier = await trinityContract.bonusMultiplier();
    const highEsgThreshold = await trinityContract.highEsgThreshold();

    console.log(`   Taxa de recompensa base: ${baseRewardRate} GST por 1.0 ESG Score`);
    console.log(`   Multiplicador de bonus: ${bonusMultiplier}%`);
    console.log(`   Threshold para bonus: ${highEsgThreshold}%`);

    // Testar funcionalidade
    console.log("\n🧪 Testando funcionalidade em Goerli...");

    const testNFEData = {
        chaveAcesso: "35240114200166000187550010000000271123456789",
        valorTotal: ethers.parseEther("2500"),
        categoria: "Energia Renovavel",
        municipio: "São Paulo",
        uf: "SP",
        cnpjEmitente: "14200166000187",
        cnpjDestinatario: "12345678000195",
        dataEmissao: Math.floor(Date.now() / 1000),
        isVerificada: true
    };

    console.log("   📊 Analisando NFe de teste...");
    const tx = await trinityContract.analyzeNFEWithTrinity(testNFEData);
    const receipt = await tx.wait();

    console.log(`   ✅ Análise concluída! Gas usado: ${receipt.gasUsed}`);
    console.log(`   💰 Custo em Goerli: GRATUITO`);

    // Obter ESG Score
    const esgScore = await trinityContract.getESGScore(testNFEData.chaveAcesso);
    console.log(`   📈 ESG Score: ${esgScore.totalScore}%`);
    console.log(`   🌱 Ambiental: ${esgScore.environmental}%`);
    console.log(`   👥 Social: ${esgScore.social}%`);
    console.log(`   🏛️ Governança: ${esgScore.governance}%`);
    console.log(`   🎯 Confiança: ${esgScore.confidence}%`);

    // Obter recompensas
    const rewards = await trinityContract.getRewards(testNFEData.chaveAcesso);
    console.log(`   💰 Recompensa GST: ${ethers.formatEther(rewards.gstAmount)} GST`);
    console.log(`   🤖 Recompensa AET: ${ethers.formatEther(rewards.aetAmount)} AET`);

    // Testar otimização Trinity
    console.log("\n⚡ Testando otimização Trinity...");
    const optimizationTx = await trinityContract.optimizeWithTrinity();
    const optimizationReceipt = await optimizationTx.wait();

    console.log(`   ✅ Otimização concluída! Gas usado: ${optimizationReceipt.gasUsed}`);
    console.log(`   💰 Custo em Goerli: GRATUITO`);

    // Resumo final
    console.log("\n🎉 DEPLOY GOERLI CONCLUÍDO!");
    console.log("=" * 60);
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log(`🏗️ Trinity ESG Contract: ${trinityAddress}`);
    console.log(`🔗 GST Token: ${gstAddress}`);
    console.log(`🔗 AET Token: ${aetAddress}`);
    console.log(`💰 Custo total: GRATUITO (ETH de teste)`);

    console.log("\n🌐 Verificar no Etherscan:");
    console.log(`   Trinity Contract: https://goerli.etherscan.io/address/${trinityAddress}`);
    console.log(`   GST Token: https://goerli.etherscan.io/address/${gstAddress}`);
    console.log(`   AET Token: https://goerli.etherscan.io/address/${aetAddress}`);

    console.log("\n💡 Para testar:");
    console.log("npx hardhat console --network goerli");
    console.log(`const Trinity = await ethers.getContractAt("TrinityESGContract", "${trinityAddress}")`);
    console.log("await Trinity.baseRewardRate()");

    console.log("\n🧠 Trinity AI: Sistema ESG + Blockchain em Goerli!");
    console.log("⚡ 100% GRATUITO - ETH de teste!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro fatal:", error);
        process.exit(1);
    });
