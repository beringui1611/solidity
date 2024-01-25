// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Colchao {

IERC20 public token;
mapping(address => uint) public balances;

constructor(address tokenAddress){
    token = IERC20(tokenAddress);
}

function deposit(uint amount) external {
    token.transferFrom(msg.sender, address(this), amount);
    balances[msg.sender] += amount;

}

function withdraw(uint amount) external {
    require(balances[msg.sender] >= amount, "Yout dont have amount");
    balances[msg.sender] -= amount; //sempre deduzir antes de transferir para medidas de segurança
    token.transfer(msg.sender, amount);
    
}

//consigo guardar qualquer protocolo (token) neste meu protocolo
// faz um deposito e um saque

}