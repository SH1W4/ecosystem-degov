const ethers = require('ethers');

async function main() {
    // Tenta detectar a versão e usar o provider correto
    let provider;
    try {
        // Ethers v6
        provider = new ethers.JsonRpcProvider('https://rpc.sepolia.org');
    } catch (e) {
        // Ethers v5
        provider = new ethers.providers.JsonRpcProvider('https://rpc.sepolia.org');
    }

    const address = '0x863de15091DfE5C044Dc1bD54f85210B6Bb6DA76';

    console.log(`Checking balance for: ${address}`);

    try {
        const balance = await provider.getBalance(address);
        // Formatação compatível com v5 e v6
        const balanceInEth = ethers.formatEther ? ethers.formatEther(balance) : ethers.utils.formatEther(balance);

        console.log(`Balance: ${balanceInEth} ETH`);

        if (parseFloat(balanceInEth) < 0.01) {
            console.log("⚠️  Low balance! You might need more ETH for deployment.");
        } else {
            console.log("✅ Sufficient balance for basic deployment.");
        }
    } catch (error) {
        console.error("Error checking balance:", error.message);
    }
}

main();
