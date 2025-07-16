/*
To solve this level, you only need to provide the Ethernaut with a Solver, 
a contract that responds to whatIsTheMeaningOfLife() with the right 32 byte number.

Easy right? Well... there's a catch.

The solver's code needs to be really tiny. Really reaaaaaallly tiny. 
Like freakin' really really itty-bitty tiny: 10 bytes at most.

Hint: Perhaps its time to leave the comfort of the Solidity compiler momentarily, and build this one by hand O_o. That's right: Raw EVM bytecode.

Good luck!


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MagicNum} from "src/MagicNum.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Solver {
    constructor(MagicNum magicNum) {
        // https://solidity-by-example.org/app/simple-bytecode-contract/
        bytes memory bytecode =
            "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address addr;
        assembly {
            // 0x13 is the length of the bytecode, 38/2=19 bytes -> 0x13 is the hex representation of 19
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        require(addr != address(0), "Create failed");

        magicNum.setSolver(addr);
    }
}

contract MagicNumSolution is Script {
    MagicNum public magicNum = MagicNum(0x7973eC7E31Fa5f414baB62FbF1248e5123ba9006);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Solver solver = new Solver(magicNum);
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
