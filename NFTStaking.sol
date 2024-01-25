// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "contracts/ILPToken.sol";


contract NFTStaking is ERC721Holder {

    ILPtoken public reward;
    IERC721 public collection;
    mapping (uint => address) public ownerOf; // tokenId => old owner
    mapping (uint => uint) public depositeDate;

    uint public rewardPerPeriod = 1000;
    uint public duration = 30 * 24 * 60 * 60;// 30 days

    constructor(address _collection, address _reward){
        collection = IERC721(_collection);
        reward = ILPToken(_reward);
    }

    function deposit(uint tokenId) external {
        collection.safeTransferFrom(msg.sender, address(this), tokenId); // deposita a nft
        ownerOf[tokenId] = msg.sender;
        depositeDate[tokenId] = block.timestamp;
        //IOU (eu le devo)
    }

    function withdraw(uint tokenId) external {
        require(ownerOf[tokenId] == msg.sender, "Unauthorized");
        require(block.timestamp >= depositeDate[tokenId] + duration, "NFT locked");
        delete ownerOf[tokenId];
        delete depositeDate[tokenId];

        collection.safeTransferFrom(address(this), msg.sender, tokenId);
        reward.mint(msg.sender, rewardPerPeriod);


    }


    function canWitdraw(uint tokenId) external view returns (bool){
        return ownerOf[tokenId] == msg.sender && block.timestamp >= depositeDate[tokenId] + duration;
    }
}