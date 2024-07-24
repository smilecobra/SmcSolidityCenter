// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Smc721Module} from "../src/Smc721Module.sol";
import {DeploySmc721Module} from "../script/DeploySmc721Module.s.sol";

contract TestSmc721 is Test{
    DeploySmc721Module depoloer;
    Smc721Module smc721Module;

    address OPERATOR = makeAddr("operator");
    address PLAYER = makeAddr("player");

    function setUp() public {
        depoloer = new DeploySmc721Module();
        smc721Module = depoloer.run(address(this), OPERATOR);

        vm.deal(PLAYER, 1 ether);
    }

    // function testMint() public {
    //     Smc721Module.mint(PLAYER, 1);

    //     assertEq(Smc721Module.ownerOf(1), PLAYER);
    //     assertEq(Smc721Module.balanceOf(PLAYER), 1);
    // }

    // function testTokensOf() public {
    //     Smc721Module.mint(PLAYER, 1);
    //     Smc721Module.mint(PLAYER, 2);
    //     Smc721Module.mint(PLAYER, 99);

    //     uint256[] memory tokens = Smc721Module.tokensOf(PLAYER);
    //     assertEq(tokens.length, 3);
    //     assertEq(tokens[0], 1);
    //     assertEq(tokens[1], 2);
    //     assertEq(tokens[2], 99);

    //     vm.prank(PLAYER);
    //     Smc721Module.burn(1);
    //     tokens = Smc721Module.tokensOf(PLAYER);
    //     assertEq(tokens.length, 2);

    //     assertEq(tokens[0], 99);
    //     assertEq(tokens[1], 2);
    // }
}