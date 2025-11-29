const hre = require("hardhat");

async function main() {
    console.log("🔍 Diagnosticando conexão (via Hardhat)...");

    // 1. Verificar variáveis de ambiente (Hardhat já carrega .env)
    // Nota: Hardhat config lê .env e coloca em process.env
    const rpcUrl = process.env.SEPOLIA_RPC_URL;
    const privateKey = process.env.PRIVATE_KEY;

    console.log("1. Verificando .env:");
    if (!rpcUrl) {
        console.error("❌ SEPOLIA_RPC_URL não encontrado no .env");
    } else {
        console.log(`✅ SEPOLIA_RPC_URL encontrado: ${rpcUrl.substring(0, 20)}...`);
    }

    if (!privateKey) {
        console.error("❌ PRIVATE_KEY não encontrado no .env");
    } else {
        console.log(`✅ PRIVATE_KEY encontrado (Tamanho: ${privateKey.length})`);
        if (privateKey.startsWith('0x')) {
            console.warn("⚠️ AVISO: PRIVATE_KEY começa com '0x'. Isso pode causar erro. Remova o '0x'.");
        }
    }

    if (!rpcUrl || !privateKey) return;

    // 2. Testar Provider e Wallet usando ethers do Hardhat
    console.log("\n2. Testando conexão e Wallet...");
    try {
        // Tenta criar wallet diretamente
        const provider = new hre.ethers.providers.JsonRpcProvider(rpcUrl);
        const wallet = new hre.ethers.Wallet(privateKey, provider);

        console.log(`✅ Wallet carregada: ${wallet.address}`);

        const balance = await wallet.getBalance();
        console.log(`💰 Saldo: ${hre.ethers.utils.formatEther(balance)} ETH`);

        if (balance.eq(0)) {
            console.warn("⚠️ ALERTA: Saldo é 0 ETH. Você precisa de ETH de teste para o deploy!");
        } else {
            console.log("✅ Saldo suficiente para iniciar.");
        }

    } catch (error) {
        console.error("\n❌ ERRO DE CONEXÃO:");
        console.error(error.message);
    }
}

main();
