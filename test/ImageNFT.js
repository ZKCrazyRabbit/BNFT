const { artifacts, assert, web3 } = require("hardhat");

const ImageNFT = artifacts.require("ImageNFT");

describe('ImageNFT contract', function () {
    let accounts;
    before(async function () {
        // 钱包中添加账户
        web3.eth.accounts.wallet.add(process.env.TEST_PRIV_KEY);
        accounts = await web3.eth.getAccounts();
        console.info('accounts: ', accounts);
    });

    describe('mint value', function () {
        it('without whitelist', async function () {
            const imageNFT = await ImageNFT.new();
            const value = await imageNFT.getMintValue();
            assert.equal(value, 1);

            // 设置value为2
            await imageNFT.updateMintValue(2);
            const value2 = await imageNFT.getMintValue();
            assert.equal(value2, 2);
        });

        it('with whitelist', async function () {
            const imageNFT = await ImageNFT.new();

            const whitelist = await imageNFT.listWhiteList();
            console.log('whitelist: ', whitelist);
            // 对address加白(小写)
            const myAddress = '0xbc7420a462af2e57a47fb3755d0e52c6031db93d';
            await imageNFT.updateWhiteList([myAddress]);
            const whitelist2 = await imageNFT.listWhiteList();
            console.log('whitelist: ', whitelist2);

            // 设置value为2
            await imageNFT.updateMintValue(2);

            const value = await imageNFT.getMintValue();
            assert.equal(value, 1);
        });
    });
});