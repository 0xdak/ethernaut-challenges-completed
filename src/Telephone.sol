// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "lib/forge-std/src/console.sol";

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
