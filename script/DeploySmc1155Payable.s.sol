// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Smc1155Payable} from '../src/Smc1155Payable.sol';

contract DeploySmc1155Payable is Script{
    Smc1155Payable smc1155Payable;

    function run(address sender, address operator) external returns(Smc1155Payable){
        vm.startBroadcast();
        smc1155Payable = new Smc1155Payable("");
        smc1155Payable.setOperator(operator);
        smc1155Payable.transferOwnership(sender);
        vm.stopBroadcast();
        return smc1155Payable;
    }
}