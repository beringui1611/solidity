// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract LiquidityToken is ERC20 {

    address public immutable owner;
    address public liquidityMining;

constructor() ERC20("PluralCoin", "PLC"){
    owner = msg.sender;

}

function setLiquidtyMining(address _liquidityMining) external { //seta o contrato de mining
require(msg.sender == owner, "You dont have permission");
liquidityMining = _liquidityMining;
}

function mint(address receiver,uint amount)external {
require(msg.sender == owner || msg.sender == liquidityMining, "Unauthorized");
_mint(receiver, amount);
}

}

