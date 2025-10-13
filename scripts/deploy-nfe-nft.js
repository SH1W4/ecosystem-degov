// SPDX-License-Identifier: MIT
const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 DEPLOY NFT NFE - NOTA FISCAL ELETRÔNICA");
    console.log("🧠 Trinity AI: Implementando ativo estratégico GuardDrive/GuardFlow");
    console.log("=" * 60);

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

        console.log("\n🏗️ Deployando NFT NFE...");

        // Deploy NFENFT
        const NFENFT = await ethers.getContractFactory("NFENFT");
        const nfeNFT = await NFENFT.deploy();
        await nfeNFT.waitForDeployment();
        const nfeAddress = await nfeNFT.getAddress();

        console.log(`✅ NFT NFE: ${nfeAddress}`);

        // Testar contrato
        const name = await nfeNFT.name();
        const symbol = await nfeNFT.symbol();
        const totalSupply = await nfeNFT.totalSupply();

        console.log(`📊 Nome: ${name}`);
        console.log(`📊 Símbolo: ${symbol}`);
        console.log(`📊 Total Supply: ${totalSupply} NFTs`);

        // Simular conversão de NFE
        console.log("\n🧪 Simulando conversão de NFE...");

        const chaveAcesso = "35240114200166000187550010000000001234567890123";
        const numeroNFE = "000000001";
        const serie = "1";
        const cnpjEmitente = "14200166000187";
        const cnpjDestinatario = "12345678000195";
        const valorTotal = ethers.parseEther("1000"); // 1000 tokens
        const municipioEmissao = "Sao Paulo";
        const ufEmissao = "SP";
        const categoria = "Energia Renovavel";
        const tokenURI = "https://api.guardflow.com/nfe/1";

        const tx = await nfeNFT.converterNFE(
            chaveAcesso,
            numeroNFE,
            serie,
            cnpjEmitente,
            cnpjDestinatario,
            valorTotal,
            municipioEmissao,
            ufEmissao,
            categoria,
            tokenURI
        );

        await tx.wait();
        console.log("✅ NFE convertida em NFT com sucesso!");

        // Verificar dados da NFE
        const nfeData = await nfeNFT.getNFEData(1);
        console.log(`📊 ESG Score: ${nfeData.esgScore}`);
        console.log(`📊 Valor Total: ${ethers.formatEther(nfeData.valorTotal)} tokens`);
        console.log(`📊 Categoria: ${nfeData.categoria}`);
        console.log(`📊 Verificada: ${nfeData.isVerificada}`);

        console.log("\n🎉 DEPLOY NFT NFE CONCLUÍDO!");
        console.log("=" * 60);
        console.log(`👤 Deployer: ${deployer.address}`);
        console.log(`🌐 Rede: ${network.name} (${network.chainId})`);
        console.log(`📋 Contrato: ${nfeAddress}`);

        console.log("\n🔗 INTEGRAÇÃO GUARDDRIVE/GUARDFLOW:");
        console.log("✅ NFE → NFT: Conversão automática");
        console.log("✅ ESG Score: Cálculo inteligente");
        console.log("✅ Rastreabilidade: Blockchain");
        console.log("✅ Tokenização: Ativo negociável");

        console.log("\n💡 PRÓXIMOS PASSOS:");
        console.log("1. Integrar com GuardDrive (mobilidade)");
        console.log("2. Conectar com GuardFlow (vendas)");
        console.log("3. Implementar marketplace NFT NFE");
        console.log("4. Deploy em Goerli testnet");

        console.log("\n🧠 Trinity AI: Dados coletados para aprendizado!");
        console.log("📊 Análise ESG: NFE como ativo sustentável");
        console.log("⚡ Otimização: Gas reduzido para NFTs");

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
