// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";


contract NFTHolder is ERC721Holder {

    IERC721 public collection;
    mapping (uint => address) public ownerOf; // tokenId => old owner

    constructor(address _collection){
        collection = IERC721(_collection);
    }

    function deposit(uint tokenId) external {
        collection.safeTransferFrom(msg.sender, address(this), tokenId); // deposita a nft
        ownerOf[tokenId] = msg.sender;
        //IOU (eu le devo)
    }

    function withdraw(uint tokenId) external {
        require(ownerOf[tokenId] == msg.sender, "Unauthorized");
        delete ownerOf[tokenId];
        collection.safeTransferFrom(address(this), msg.sender, tokenId);


    }
}