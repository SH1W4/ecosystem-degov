const fs = require('fs');
const path = require('path');
const ethers = require('ethers');

async function main() {
    console.log("🔍 Diagnosticando conexão (Standalone)...");

    // 1. Ler .env manualmente
    const envPath = path.join(__dirname, '..', '.env');
    let rpcUrl = '';
    let privateKey = '';

    try {
        const envContent = fs.readFileSync(envPath, 'utf8');
        const lines = envContent.split('\n');
        for (const line of lines) {
            if (line.startsWith('SEPOLIA_RPC_URL=')) {
                rpcUrl = line.split('=')[1].trim();
            }
            if (line.startsWith('PRIVATE_KEY=')) {
                privateKey = line.split('=')[1].trim();
            }
        }
    } catch (e) {
        console.error("❌ Erro ao ler arquivo .env:", e.message);
        return;
    }

    console.log("1. Verificando credenciais:");
    if (!rpcUrl) {
        console.error("❌ SEPOLIA_RPC_URL não encontrado");
    } else {
        console.log(`✅ SEPOLIA_RPC_URL encontrado: ${rpcUrl.substring(0, 25)}...`);
    }

    if (!privateKey) {
        console.error("❌ PRIVATE_KEY não encontrado");
    } else {
        console.log(`✅ PRIVATE_KEY encontrado (Tamanho: ${privateKey.length})`);
    }

    if (!rpcUrl || !privateKey) return;

    // 2. Testar Conexão
    console.log("\n2. Testando conexão...");
    try {
        // Tenta detectar versão do ethers
        let provider;
        if (ethers.JsonRpcProvider) { // v6
            provider = new ethers.JsonRpcProvider(rpcUrl);
        } else { // v5
            provider = new ethers.providers.JsonRpcProvider(rpcUrl);
        }

        const network = await provider.getNetwork();
        console.log(`✅ Conectado! Rede: ${network.name} (Chain ID: ${network.chainId})`);

        // 3. Testar Wallet
        console.log("\n3. Testando Wallet...");
        const wallet = new ethers.Wallet(privateKey, provider);
        console.log(`✅ Wallet carregada: ${wallet.address}`);

        const balance = await provider.getBalance(wallet.address);
        const balanceEth = ethers.utils ? ethers.utils.formatEther(balance) : ethers.formatEther(balance);

        console.log(`💰 Saldo: ${balanceEth} ETH`);

        if (parseFloat(balanceEth) === 0) {
            console.warn("⚠️ ALERTA: Saldo é 0 ETH. Você precisa de ETH de teste!");
        } else {
            console.log("✅ Saldo suficiente.");
        }

    } catch (error) {
        console.error("\n❌ ERRO DE CONEXÃO:");
        console.error(error.message);
    }
}

main();
