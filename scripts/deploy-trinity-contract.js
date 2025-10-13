// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🧠 Deployando Trinity ESG Contract...");

    const [deployer] = await ethers.getSigners();
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log(`💰 Saldo do deployer: ${ethers.formatEther(await ethers.provider.getBalance(deployer.address))} ETH`);

    // Endereços dos tokens (assumindo que já foram deployados)
    const GST_TOKEN_ADDRESS = "0x5fbdb2315678afecb367f032d93f642f64180aa3"; // GST Token
    const AET_TOKEN_ADDRESS = "0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0"; // AET Token
    const NFE_NFT_ADDRESS = "0x0000000000000000000000000000000000000000"; // NFT NFe (será deployado depois)

    console.log("\n📋 Endereços dos tokens:");
    console.log(`   GST Token: ${GST_TOKEN_ADDRESS}`);
    console.log(`   AET Token: ${AET_TOKEN_ADDRESS}`);
    console.log(`   NFT NFe: ${NFE_NFT_ADDRESS}`);

    // Deploy Trinity ESG Contract
    console.log("\n🏗️ Deployando TrinityESGContract...");
    const TrinityESGContract = await ethers.getContractFactory("TrinityESGContract");
    const trinityContract = await TrinityESGContract.deploy(
        GST_TOKEN_ADDRESS,
        AET_TOKEN_ADDRESS,
        NFE_NFT_ADDRESS
    );
    await trinityContract.waitForDeployment();

    console.log(`✅ Trinity ESG Contract: ${await trinityContract.getAddress()}`);

    // Verificar configurações
    console.log("\n⚙️ Configurações do contrato:");
    const baseRewardRate = await trinityContract.baseRewardRate();
    const bonusMultiplier = await trinityContract.bonusMultiplier();
    const highEsgThreshold = await trinityContract.highEsgThreshold();

    console.log(`   Taxa de recompensa base: ${baseRewardRate} GST por 1.0 ESG Score`);
    console.log(`   Multiplicador de bonus: ${bonusMultiplier}%`);
    console.log(`   Threshold para bonus: ${highEsgThreshold}%`);

    // Testar funcionalidade básica
    console.log("\n🧪 Testando funcionalidade básica...");

    // Simular análise de NFe
    const testNFEData = {
        chaveAcesso: "35240114200166000187550010000000271123456789",
        valorTotal: ethers.parseEther("2500"), // 2500 tokens
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
    console.log(`   📈 Melhoria: 15% (simulada)`);

    // Resumo final
    console.log("\n🎉 DEPLOY TRINITY ESG CONTRACT CONCLUÍDO!");
    console.log("=" * 60);
    console.log(`👤 Deployer: ${deployer.address}`);
    console.log(`🏗️ Trinity ESG Contract: ${await trinityContract.getAddress()}`);
    console.log(`🔗 GST Token: ${GST_TOKEN_ADDRESS}`);
    console.log(`🔗 AET Token: ${AET_TOKEN_ADDRESS}`);
    console.log(`🔗 NFT NFe: ${NFE_NFT_ADDRESS}`);

    console.log("\n💡 Para testar:");
    console.log("npx hardhat console --network localhost");
    console.log(`const Trinity = await ethers.getContractAt("TrinityESGContract", "${await trinityContract.getAddress()}")`);
    console.log("await Trinity.baseRewardRate()");
    console.log("await Trinity.bonusMultiplier()");
    console.log("await Trinity.highEsgThreshold()");

    console.log("\n🧠 Trinity AI: Contrato ESG integrado com rede neural!");
    console.log("⚡ Sistema pronto para análise ESG automática!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro fatal:", error);
        process.exit(1);
    });
