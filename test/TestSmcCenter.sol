// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.18;

// import {Test, console} from "forge-std/Test.sol";
// import {SmcCenter} from "../src/SmcCenter.sol";
// import {DeploySmcCenter} from "../script/DeploySmcCenter.s.sol";
// import {Smc1155} from "../src/Smc1155.sol";
// import {DeploySmc1155} from "../script/DeploySmc1155.s.sol";
// import {Smc721Module} from "../src/Smc721Module.sol";
// import {DeploySmc721Module} from "../script/DeploySmc721Module.s.sol";

// contract TestSmcCenter is Test{
//     DeploySmcCenter centerDepoloer;
//     SmcCenter smcCenter;
//     DeploySmc1155 depoloer;
//     Smc1155 smc1155;
//     Smc721Module smc721Module;

//     address PLAYER = makeAddr("player");

//     address[] public addrs;
//     uint256[] public types;
//     uint256[] public ids;
//     uint256[] public values;

//     function setUp() public {
//         centerDepoloer = new DeploySmcCenter();
//         (smcCenter, smc1155, smc721Module) = centerDepoloer.run();

//         vm.deal(PLAYER, 1 ether);
//     }

//     function testMint() public{
//         vm.prank(address(smcCenter));
//         smc1155.mint(PLAYER, 1, 1, "");
//         vm.prank(address(smcCenter));
//         smc1155.mint(PLAYER, 1, 1, "");
//         uint256 balance = smc1155.balanceOf(PLAYER, 1);
//         assertEq(balance, 2);
//     }

//     function testCenterMint() public{
//         addrs.push(address(smc1155));
//         types.push(1155);
//         ids.push(1);
//         values.push(1);

//         addrs.push(address(smc721Module));
//         types.push(721);
//         ids.push(1);
//         values.push(1);

//         addrs.push(address(smc721Module));
//         types.push(721);
//         ids.push(2);
//         values.push(1);

//         addrs.push(address(smc1155));
//         types.push(1155);
//         ids.push(2);
//         values.push(1);

//         addrs.push(address(smc1155));
//         types.push(1155);
//         ids.push(3);
//         values.push(3);

//         smcCenter.mint(
//             PLAYER,
//             addrs,
//             types,
//             ids,
//             values
//         );

//         console.log(smc1155.balanceOf(PLAYER, 1));
//         console.log(smc1155.balanceOf(PLAYER, 2));
//         console.log(smc1155.balanceOf(PLAYER, 3));

//         assertEq(smc1155.balanceOf(PLAYER, 1), 1);
//         assertEq(smc1155.balanceOf(PLAYER, 2), 1);
//         assertEq(smc1155.balanceOf(PLAYER, 3), 3);

//         console.log(smc721Module.balanceOf(PLAYER));

//         assertEq(smc721Module.balanceOf(PLAYER), 2);
//         assertEq(smc721Module.tokensOf(PLAYER)[0], 1);
//         assertEq(smc721Module.tokensOf(PLAYER)[1], 2);
//     }

//     function testCenterBurn() public{
//         addrs.push(address(smc1155));
//         types.push(1155);
//         ids.push(1);
//         values.push(1);

//         addrs.push(address(smc721Module));
//         types.push(721);
//         ids.push(1);
//         values.push(1);

//         addrs.push(address(smc721Module));
//         types.push(721);
//         ids.push(2);
//         values.push(1);

//         addrs.push(address(smc1155));
//         types.push(1155);
//         ids.push(2);
//         values.push(1);

//         addrs.push(address(smc1155));
//         types.push(1155);
//         ids.push(3);
//         values.push(3);

//         SmcCenter.mint(
//             PLAYER,
//             addrs,
//             types,
//             ids,
//             values
//         );

//         // vm.expectRevert();
//         // SmcCenter.burn(
//         //     PLAYER,
//         //     addrs,
//         //     types,
//         //     ids,
//         //     values
//         // );

//         vm.prank(PLAYER);
//         smc1155.setApprovalForAll(address(smcCenter), true);
//         vm.prank(PLAYER);
//         smc721Module.setApprovalForAll(address(smcCenter), true);

//         SmcCenter.burn(
//             PLAYER,
//             addrs,
//             types,
//             ids,
//             values
//         );
//     }
// }