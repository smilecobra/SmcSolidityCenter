// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Smc1155} from "../src/Smc1155.sol";
import {DeploySmc1155} from "../script/DeploySmc1155.s.sol";

contract TestSmc1155 is Test{
    DeploySmc1155 depoloer;
    Smc1155 smc1155;

    address OPERATOR = makeAddr("operator");
    address PLAYER = makeAddr("player");
    address PLAYER2 = makeAddr("player2");

    function setUp() public {
        depoloer = new DeploySmc1155();
        smc1155 = depoloer.run(msg.sender, OPERATOR);

        vm.deal(PLAYER, 1 ether);
    }

    function testMint() public {
        vm.prank(smc1155.owner());
        smc1155.mint(PLAYER, 1, 1, "");
        uint256 balance = smc1155.balanceOf(PLAYER, 1);
        assertEq(balance, 1);
    }

    function testBurn() public{
        vm.prank(PLAYER);
        vm.expectRevert();
        smc1155.burn(PLAYER, 1, 1);
    }

    function testBurnAsOwner() public{
        vm.prank(smc1155.owner());
        smc1155.mint(PLAYER, 1, 1, "");

        vm.prank(smc1155.owner());
        smc1155.burn(PLAYER, 1, 1);
    }

    function testBurnAsApproval() public{
        vm.prank(smc1155.owner());
        smc1155.mint(PLAYER, 1, 1, "");

        vm.startPrank(PLAYER);
        smc1155.setApprovalForAll(PLAYER2, true);
        vm.stopPrank();

        vm.prank(PLAYER2);
        smc1155.burn(PLAYER, 1, 1);
    }
}