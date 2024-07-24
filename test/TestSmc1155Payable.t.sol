// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Smc1155Payable} from "../src/Smc1155Payable.sol";
import {DeploySmc1155Payable} from '../script/DeploySmc1155Payable.s.sol';

contract TestSmc1155Payable is Test{
    DeploySmc1155Payable depoloer;
    Smc1155Payable smc1155Payable;

    address OPERATOR = makeAddr("operator");
    address PLAYER = makeAddr("player");

    uint256 AMOUNT = 3;
    uint256 TOKEN_PRICE = 1e14;

    function setUp() public {
        depoloer = new DeploySmc1155Payable();
        smc1155Payable = depoloer.run(msg.sender, OPERATOR);

        vm.deal(PLAYER, 1000 ether);
    }

    function testSetTokenPrice() public{
        vm.prank(smc1155Payable.owner());
        smc1155Payable.setTokenPrice(1, TOKEN_PRICE);

        vm.assertEq(smc1155Payable.getTokenPrice(1), TOKEN_PRICE);
    }

    function testPay2Mint() public{
        uint256 owner_balance = smc1155Payable.owner().balance;

        vm.prank(smc1155Payable.owner());
        smc1155Payable.setTokenPrice(1, TOKEN_PRICE);
        vm.prank(PLAYER);
        smc1155Payable.pay2Mint{value: AMOUNT * TOKEN_PRICE}(1, AMOUNT, "");

        uint256 owner_balance_after = smc1155Payable.owner().balance;

        vm.assertEq(owner_balance_after - owner_balance, AMOUNT * TOKEN_PRICE);
    }
}