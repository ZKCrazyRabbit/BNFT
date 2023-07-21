const { artifacts, contract, assert } = require("hardhat");

const ImageNFT = artifacts.require("ImageNFT");

contract("ImageNFT", accounts => {
    it("gasPrice", async function () {
        const imageNFT = await ImageNFT.new();
        const gasPrice = 10000;
        await imageNFT.updateGasPrice(gasPrice);
        assert.equal(await imageNFT.getOriginGasPrice(), gasPrice);
    });

    it("image", async function () {
        const imageNFT = await ImageNFT.new();
        const images = [
            { id: 1, ipfshash: 'https://1.json' },
            { id: 2, ipfshash: 'https://2.json' },
        ];
        for (let i = 0; i < images.length; i++) {
            const val = images[i];
            await imageNFT.upsertImage(val.id, val.ipfshash);
        }

        const nftImage = await imageNFT.getImageById(1);
        console.log('nftImage: ', nftImage);
        assert.equal(nftImage.ipfsHash, images[0].ipfshash);

        const nftImages = await imageNFT.listImage();
        console.log('nft images: ', nftImages);
        assert.equal(nftImages.length, 2);

        const newIpfshash = 'https://3.json';
        await imageNFT.upsertImage(1, newIpfshash);
        const newNftImage = await imageNFT.getImageById(1);
        assert.equal(newNftImage.ipfsHash, newIpfshash);

        await imageNFT.removeImage(2);
        const afterRemoveImages = await imageNFT.listImage();
        console.log('after remove images: ', afterRemoveImages);
        assert.equal(afterRemoveImages.length, 1);
    });

    it("whitelist", async function () {
        const imageNFT = await ImageNFT.new();
        const myAddress = '0xbC7420a462aF2e57a47fB3755D0e52c6031dB93D';
        await imageNFT.updateWhiteList([myAddress]);
        const whitelist = await imageNFT.listWhiteList();
        console.log('whitelist: ', whitelist);
        assert.equal(whitelist.length, 1);
    });
});