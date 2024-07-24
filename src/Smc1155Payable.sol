// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Smc1155} from './Smc1155.sol';
import {SmcPermission} from "./SmcPermission.sol";

contract Smc1155Payable is Smc1155 {
    error Raffle__NotMintable();
    error Raffle__NotEnoughEther();
    error Raffle__TransfetErr();

    mapping (uint256 => uint256) private payableIds;

    constructor(string memory uri) Smc1155(uri) {}

    function setTokenPrice(uint256 id, uint256 gas) public onlyAuth{
        payableIds[id] = gas;
    }

    function getTokenPrice(uint256 id) public view returns(uint256){
        return payableIds[id];
    }

    function pay2Mint(uint256 id, uint256 amount, bytes memory data) public payable{
        if(payableIds[id] == 0){
            revert Raffle__NotMintable();
        }
        uint256 value = payableIds[id] * amount;
        if(msg.value < value){
            revert Raffle__NotEnoughEther();
        }
        (bool success,) = owner().call{value: msg.value}("");
        if(!success){
            revert Raffle__TransfetErr();
        }

        _mint(msg.sender, id, amount, data);
    }
}