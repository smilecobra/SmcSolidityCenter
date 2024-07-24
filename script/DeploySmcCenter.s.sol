// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SmcCenter} from "../src/SmcCenter.sol";
import {Smc1155} from "../src/Smc1155.sol";
import {Smc1155Payable} from "../src/Smc1155Payable.sol";
import {Smc721Module} from "../src/Smc721Module.sol";
import {console} from "forge-std/Test.sol";

contract DeploySmcCenter is Script{
    SmcCenter smcCenter;
    Smc1155 smc1155;
    Smc1155Payable smc1155Payable;
    Smc721Module smc721Module;
    function run() external returns(SmcCenter, Smc1155Payable){
        vm.startBroadcast();
        smcCenter = new SmcCenter(msg.sender);

        // Smc1155 = new Smc1155("");
        // Smc1155.setOperator(address(SmcCenter));
        // Smc1155.transferOwnership(msg.sender);                                                                                                                                                                                                                                                                                                                                                                                            

        // Smc721Module = new Smc721Module("");
        // Smc721Module.setOperator(address(SmcCenter));
        // Smc721Module.transferOwnership(msg.sender);
        // vm.stopBroadcast();

        smc1155Payable = new Smc1155Payable("https://api.smilecobra.io/chain/metadata?contract_id=25&id={id}");
        smc1155Payable.setTokenPrice(1, 300000000000000);
        smc1155Payable.setOperator(address(smcCenter));
        smc1155Payable.transferOwnership(msg.sender);

        return (smcCenter, smc1155Payable);
    }
}