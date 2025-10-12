const { ethers } = require("hardhat");

async function main() {
    console.log("🤖 Transferindo AET Tokens para carteira...");

    // Endereço do contrato AET (substitua pelo endereço real)
    const AET_CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Substitua pelo endereço real

    // Endereço da carteira de destino (substitua pelo seu endereço)
    const WALLET_ADDRESS = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"; // Substitua pelo seu endereço

    // Quantidade de AET para transferir (em wei)
    const AMOUNT = ethers.parseEther("1000"); // 1000 AET

    // Conectar ao contrato
    const AETToken = await ethers.getContractFactory("SimpleAETToken");
    const aetToken = AETToken.attach(AET_CONTRACT_ADDRESS);

    // Verificar saldo atual
    const currentBalance = await aetToken.balanceOf(WALLET_ADDRESS);
    console.log("💰 Saldo atual da carteira:", ethers.formatEther(currentBalance), "AET");

    // Transferir tokens
    console.log("📤 Transferindo", ethers.formatEther(AMOUNT), "AET para", WALLET_ADDRESS);

    const tx = await aetToken.transfer(WALLET_ADDRESS, AMOUNT);
    await tx.wait();

    console.log("✅ Transferência realizada!");
    console.log("📋 Transaction hash:", tx.hash);

    // Verificar saldo final
    const finalBalance = await aetToken.balanceOf(WALLET_ADDRESS);
    console.log("💰 Saldo final da carteira:", ethers.formatEther(finalBalance), "AET");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("❌ Erro:", error);
        process.exit(1);
    });
