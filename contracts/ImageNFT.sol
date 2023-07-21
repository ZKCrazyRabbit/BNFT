// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ImageNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Crazy Rabbit", "IMGNFT") {}

    struct Image {
        uint256 id;
        string ipfsHash;
    }

    mapping(uint256 => Image) private _images;
    Image[] private _image_list;

    // 手续费价格
    uint256 private _gasPrice;

    // 白名单用户
    mapping(address => bool) private _whitelist;
    address[] private _whitelist_arr;

    // mint事件通知
    event Mint(address indexed from, uint256 value);

    function mint(uint256 imageId) public payable returns (uint256) {
        require(imageId > 0, "Invalid image id");
        Image memory image = getImageById(imageId);
        require(isStringNotEmpty(image.ipfsHash), "Image is not exists");

        _tokenIds.increment();
        uint256 newImageId = _tokenIds.current();
        _mint(msg.sender, newImageId);
        _setTokenURI(newImageId, image.ipfsHash);

        // 调用事件，记录交易人和转账金额
        emit Mint(msg.sender, msg.value);

        return newImageId;
    }

    function listImage() public view returns (Image[] memory) {
        return _image_list;
    }

    function upsertImage(uint256 id, string calldata ipfshash) public {
        Image memory image = _images[id];
        Image memory newImage = Image(id, ipfshash);
        if (isStringNotEmpty(image.ipfsHash)) {
            int256 i = findImageIndex(id);
            if (i >= 0) {
                removeImageByIndex(uint(i));
            }
        }
        _image_list.push(newImage);
        _images[id] = newImage;
    }

    function removeImage(uint256 id) public {
        delete _images[id];
        int256 i = findImageIndex(id);
        if (i >= 0) {
            removeImageByIndex(uint(i));
        }
    }

    function findImageIndex(uint256 id) private view returns (int256) {
        for (uint i = 0; i < _image_list.length; i++) {
            if (_image_list[i].id == id) {
                return int256(i);
            }
        }
        return -1;
    }

    function removeImageByIndex(uint i) private {
        _image_list[i] = _image_list[_image_list.length - 1];
        _image_list.pop();
    }

    function getImageById(uint256 imageId) public view returns (Image memory) {
        Image memory image = _images[imageId];
        return image;
    }

    function getGasPrice() public view returns (uint256) {
        if (_whitelist[msg.sender] == true) {
            return 0;
        }
        return _gasPrice;
    }

    function getOriginGasPrice() public view returns (uint256) {
        return _gasPrice;
    }

    function updateGasPrice(uint256 price) public {
        _gasPrice = price;
    }

    function listWhiteList() public view returns (address[] memory) {
        return _whitelist_arr;
    }

    function updateWhiteList(address[] calldata whitelist) public {
        for (uint i = 0; i < _whitelist_arr.length; i++) {
            delete _whitelist[_whitelist_arr[i]];
        }
        _whitelist_arr = whitelist;
        for (uint i = 0; i < whitelist.length; i++) {
            _whitelist[_whitelist_arr[i]] = true;
        }
    }

    function isStringNotEmpty(string memory str) private pure returns (bool) {
        bytes memory strBytes = bytes(str);
        if (strBytes.length == 0) {
            return false;
        } else {
            return true;
        }
    }
}
