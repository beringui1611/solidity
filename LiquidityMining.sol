// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/ILPToken.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract LiquidityMining is ReentrancyGuard {

IERC20 public token;
ILPToken public reward;
mapping(address => uint) public balances;
mapping (address => uint ) public checkPoints;//liquidity providers => deposit block

uint public rewardPerBlock = 1;

constructor(address tokenAddress, address rewardAddress){
    token = IERC20(tokenAddress);
    reward = ILPToken(rewardAddress);
}

function rewardPayment(uint balance) internal {
    uint diffrence = block.number - checkPoints[msg.sender];
    if(diffrence > 0){
        reward.mint(msg.sender,balance * diffrence * rewardPerBlock);
        checkPoints[msg.sender];
    }
}

function deposit(uint amount) external nonReentrant{
    token.transferFrom(msg.sender, address(this), amount);
    uint originalBalance = balances[msg.sender];
    balances[msg.sender] += amount;

    if(checkPoints[msg.sender] == 0){
        checkPoints[msg.sender] = block.timestamp;
    }
    else rewardPayment(originalBalance);


}

function withdraw(uint amount) external {
    require(balances[msg.sender] >= amount, "Yout dont have amount");
    uint originalBalance = balances[msg.sender];
    balances[msg.sender] -= amount; //sempre deduzir antes de transferir para medidas de segurança
    token.transfer(msg.sender, amount);
    rewardPayment(originalBalance);
    
}

function calculateRewards() external view returns(uint){
    uint difference = block.number - checkPoints[msg.sender];
    return balances[msg.sender] * difference * rewardPerBlock;
}


function liquidityPool() external view  returns (uint){
    return token.balanceOf(address(this));
}


//consigo guardar qualquer protocolo (token) neste meu protocolo
// faz um deposito e um saque

}