const hre = require("hardhat");
const fs = require('fs');
const path = require('path');

/**
 * 🚀 Deploy Simplificado para Testnet
 * 
 * Este script faz deploy do TrinityGSTToken em testnet (Sepolia/Goerli)
 * e salva os endereços para uso posterior.
 */

async function main() {
  console.log("🚀 Ecosystem Degov - Deploy em Testnet");
  console.log("=====================================\n");

  // 1. Obter informações da rede
  const network = await hre.ethers.provider.getNetwork();
  console.log(`📡 Rede: ${network.name} (chainId: ${network.chainId})`);

  // 2. Obter signer
  const [deployer] = await hre.ethers.getSigners();
  console.log(`👤 Deployer: ${deployer.address}`);

  // 3. Verificar balance
  const balance = await deployer.getBalance();
  console.log(`💰 Balance: ${hre.ethers.utils.formatEther(balance)} ETH\n`);

  if (balance.eq(0)) {
    console.error("❌ Erro: Sem ETH para deploy!");
    console.log("💡 Obtenha ETH de teste em:");
    console.log("   - Sepolia: https://sepoliafaucet.com/");
    console.log("   - Goerli: https://goerlifaucet.com/");
    process.exit(1);
  }

  // 4. Deploy TrinityGSTToken
  console.log("📝 Deploying TrinityGSTToken...");
  
  const TrinityGST = await hre.ethers.getContractFactory("TrinityGSTToken");
  const gst = await TrinityGST.deploy();
  
  console.log("⏳ Aguardando confirmação...");
  await gst.deployed();
  
  console.log(`✅ TrinityGSTToken deployed!`);
  console.log(`📍 Address: ${gst.address}\n`);

  // 5. Obter informações do deploy
  const deployTx = gst.deployTransaction;
  console.log(`🔗 Transaction hash: ${deployTx.hash}`);
  console.log(`⛽ Gas used: ${deployTx.gasLimit.toString()}`);
  console.log(`💸 Gas price: ${hre.ethers.utils.formatUnits(deployTx.gasPrice, 'gwei')} gwei\n`);

  // 6. Salvar endereços
  const deploymentsDir = path.join(__dirname, '..', 'deployments');
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir, { recursive: true });
  }

  const deploymentData = {
    network: network.name,
    chainId: network.chainId,
    contracts: {
      TrinityGSTToken: {
        address: gst.address,
        transactionHash: deployTx.hash,
        blockNumber: deployTx.blockNumber,
        deployer: deployer.address,
        deployedAt: new Date().toISOString()
      }
    },
    metadata: {
      compiler: "solc 0.8.20",
      optimizer: true,
      runs: 200
    }
  };

  const filename = `${network.name}-deployment.json`;
  const filepath = path.join(deploymentsDir, filename);
  
  fs.writeFileSync(filepath, JSON.stringify(deploymentData, null, 2));
  console.log(`💾 Deployment info saved to: deployments/${filename}\n`);

  // 7. Verificar contrato no Etherscan (se disponível)
  if (network.name !== "hardhat" && network.name !== "localhost") {
    console.log("🔍 Verificando contrato no Etherscan...");
    console.log("⏳ Aguardando 30 segundos para o Etherscan indexar...\n");
    
    await new Promise(resolve => setTimeout(resolve, 30000));

    try {
      await hre.run("verify:verify", {
        address: gst.address,
        constructorArguments: [],
      });
      console.log("✅ Contrato verificado no Etherscan!\n");
    } catch (error) {
      console.log("⚠️  Verificação falhou (pode ser feita manualmente depois)");
      console.log(`   Comando: npx hardhat verify --network ${network.name} ${gst.address}\n`);
    }
  }

  // 8. Testar funções básicas
  console.log("🧪 Testando funções básicas...");
  
  const name = await gst.name();
  const symbol = await gst.symbol();
  const totalSupply = await gst.totalSupply();
  const maxSupply = await gst.MAX_SUPPLY();
  
  console.log(`   Nome: ${name}`);
  console.log(`   Símbolo: ${symbol}`);
  console.log(`   Total Supply: ${hre.ethers.utils.formatEther(totalSupply)} GST`);
  console.log(`   Max Supply: ${hre.ethers.utils.formatEther(maxSupply)} GST\n`);

  // 9. Instruções finais
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  console.log("✅ DEPLOY CONCLUÍDO COM SUCESSO!");
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
  
  console.log("📋 Informações importantes:");
  console.log(`   • Contrato: ${gst.address}`);
  console.log(`   • Rede: ${network.name}`);
  console.log(`   • Explorer: https://${network.name}.etherscan.io/address/${gst.address}`);
  console.log(`   • Deployment: deployments/${filename}\n`);
  
  console.log("📝 Próximos passos:");
  console.log("   1. Verificar contrato no Explorer");
  console.log("   2. Testar funções via Etherscan");
  console.log("   3. Integrar com frontend");
  console.log("   4. Configurar Trinity AI Agent\n");

  console.log("💡 Comandos úteis:");
  console.log(`   • Verificar: npx hardhat verify --network ${network.name} ${gst.address}`);
  console.log(`   • Console: npx hardhat console --network ${network.name}`);
  console.log(`   • Interagir: const gst = await ethers.getContractAt("TrinityGSTToken", "${gst.address}")\n`);
}

// Execute o script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("\n❌ Erro durante deploy:");
    console.error(error);
    process.exit(1);
  });
