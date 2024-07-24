// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Smc1155} from "../src/Smc1155.sol";

contract DeploySmc1155 is Script{
    Smc1155 smc1155;

    function run(address sender, address operator) external returns(Smc1155){
        vm.startBroadcast();
        smc1155 = new Smc1155("");
        smc1155.setOperator(operator);
        smc1155.transferOwnership(sender);
        vm.stopBroadcast();
        return smc1155;
    }
}