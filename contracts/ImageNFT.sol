// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ImageNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // TODO: 使用外部函数维护
    constructor() ERC721("Crazy Rabbit", "IMGNFT") {
        _images[1] = Image(
            "https://bafybeidvjunwyuncwhfhd4ehkv7fggdg7ncglxizgflhtdgax2kftdzw5a.ipfs.w3s.link/nft_1.json"
        );
        _images[2] = Image(
            "https://bafybeifmdw5z4yx2a5akxafvvfejkygzusvwgrm5wdow5ije3p66dfr6di.ipfs.w3s.link/nft_2.json"
        );
        _images[3] = Image(
            "https://bafybeidietfaocihiwlqof4ifgs2d5lqkyujuathumtbswdybao655weo4.ipfs.w3s.link/nft_3.json"
        );
        _images[4] = Image(
            "https://bafybeiboudii4gb2q6dfbrayx57wwxohod7fs3eifpb5rimhov3mzxhnpa.ipfs.w3s.link/nft_4.json"
        );
    }

    struct Image {
        string ipfsHash;
    }

    // TODO: 增加upsert、list、delete方法
    mapping(uint256 => Image) private _images;

    // 手续费价格
    uint256 private _gasPrice;

    // 白名单用户
    // TODO: 增加list、upsert、delete方法
    mapping(address => uint) private _whitelist;

    // mint事件通知
    event Mint(address indexed from, uint256 value);

    function mint(uint256 imageId) public payable returns (uint256) {
        require(imageId > 0 && imageId <= 4, "Invalid image id");
        Image memory image = _images[imageId];

        _tokenIds.increment();
        uint256 newImageId = _tokenIds.current();
        _mint(msg.sender, newImageId);
        _setTokenURI(newImageId, image.ipfsHash);

        // 调用事件，记录交易人和转账金额
        emit Mint(msg.sender, msg.value);

        return newImageId;
    }

    function getImageById(uint256 imageId) public view returns (Image memory) {
        require(imageId > 0 && imageId <= 4, "Invalid image id");
        Image memory image = _images[imageId];
        return image;
    }

    function getGasPrice() public view returns (uint256) {
        // 判断是否为白名单用户
        if (_whitelist[msg.sender] == 1) {
            return 0;
        }
        return _gasPrice;
    }

    // 获取gas price的原始内容
    function getOriginGasPrice() public view returns (uint256) {
        return _gasPrice;
    }
}
