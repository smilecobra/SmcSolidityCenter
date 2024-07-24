// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Smc721Module} from "../src/Smc721Module.sol";

contract DeploySmc721Module is Script{
    Smc721Module smc721Module;

    function run(address sender, address operator) external returns(Smc721Module){
        vm.startBroadcast();
        smc721Module = new Smc721Module("");
        smc721Module.setOperator(operator);
        smc721Module.transferOwnership(sender);
        vm.stopBroadcast();
        return smc721Module;
    }
}