const hre = require("hardhat");

async function main() {
    const ImageNFT = await hre.ethers.getContractFactory("ImageNFT");
    const imageNFT = await ImageNFT.deploy();

    await imageNFT.deployed();
    console.log("ImageNFT deployed to: ", imageNFT.address); 
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });