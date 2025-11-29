const fs = require('fs');
const path = require('path');
const ethers = require('ethers');

async function main() {
    console.log("🚀 Iniciando Deploy Standalone (Tentativa 3 - Correção de Argumentos)...");

    // 1. Ler Configuração
    const envPath = path.join(__dirname, '..', '.env');
    const envContent = fs.readFileSync(envPath, 'utf8');
    let rpcUrl = '';
    let privateKey = '';

    envContent.split('\n').forEach(line => {
        if (line.startsWith('SEPOLIA_RPC_URL=')) rpcUrl = line.split('=')[1].trim();
        if (line.startsWith('PRIVATE_KEY=')) privateKey = line.split('=')[1].trim();
    });

    // Fallback para outros RPCs
    const rpcUrls = [
        rpcUrl,
        'https://ethereum-sepolia.publicnode.com',
        'https://rpc.sepolia.org',
        'https://sepolia.gateway.tenderly.co'
    ];

    let provider;
    let wallet;
    let connected = false;

    // Tentar conectar
    for (const url of rpcUrls) {
        if (!url) continue;
        console.log(`📡 Tentando conectar a: ${url}`);
        try {
            if (ethers.JsonRpcProvider) {
                provider = new ethers.JsonRpcProvider(url);
            } else {
                provider = new ethers.providers.JsonRpcProvider(url);
            }

            const network = await provider.getNetwork();
            console.log(`✅ Conectado! Chain ID: ${network.chainId}`);
            connected = true;
            break;
        } catch (e) {
            console.log(`❌ Falha ao conectar: ${e.message}`);
        }
    }

    if (!connected) throw new Error("Não foi possível conectar a nenhum RPC.");

    wallet = new ethers.Wallet(privateKey, provider);
    console.log(`👤 Deployer: ${wallet.address}`);

    // 3. Ler Artifacts
    const artifactPath = path.join(__dirname, '..', 'artifacts', 'contracts', 'tokens', 'TrinityGSTToken.sol', 'TrinityGSTToken.json');
    const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));

    // 4. Deploy SEM ARGUMENTOS (Construtor vazio)
    console.log("\n📝 Deploying TrinityGSTToken...");
    const factory = new ethers.ContractFactory(artifact.abi, artifact.bytecode, wallet);

    try {
        // Deploy sem argumentos
        const contract = await factory.deploy({
            gasLimit: 3000000 // Forçar gas limit alto
        });

        console.log(`⏳ Transação enviada! Hash: ${contract.deployTransaction ? contract.deployTransaction.hash : contract.deploymentTransaction().hash}`);
        console.log("⏳ Aguardando confirmação (pode demorar 1-2 min)...");

        const receipt = await contract.deployed ? contract.deployed() : contract.waitForDeployment();

        const address = contract.address || await contract.getAddress();
        console.log(`\n✅ TrinityGSTToken DEPLOYED com sucesso!`);
        console.log(`📍 Endereço: ${address}`);
        console.log(`🔗 Etherscan: https://sepolia.etherscan.io/address/${address}`);

        // Salvar endereço
        const deployInfo = {
            network: "sepolia",
            contract: "TrinityGSTToken",
            address: address,
            deployer: wallet.address,
            timestamp: new Date().toISOString()
        };

        fs.writeFileSync(
            path.join(__dirname, '..', 'deployments', 'sepolia-standalone.json'),
            JSON.stringify(deployInfo, null, 2)
        );
        console.log("💾 Informações salvas em deployments/sepolia-standalone.json");

    } catch (error) {
        console.error("\n❌ FALHA NO DEPLOY:");
        console.error("Mensagem:", error.message);
    }
}

main().catch(console.error);
