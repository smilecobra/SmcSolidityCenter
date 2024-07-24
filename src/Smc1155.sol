// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {ERC1155Burnable} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import {SmcPermission} from "./SmcPermission.sol";

contract Smc1155 is ERC1155, ERC1155Burnable, SmcPermission {

    constructor(string memory uri) ERC1155(uri) SmcPermission(msg.sender, msg.sender){}

    function setURI(string memory newuri) public onlyAuth{
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyAuth
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyAuth
    {
        _mintBatch(to, ids, amounts, data);
    }

    function burn(address account, uint256 id, uint256 value) public override approveOrAuth(account, _msgSender()){
        _burn(account, id, value);
    }

    function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public override approveOrAuth(account, _msgSender()){
        _burnBatch(account, ids, values);
    }

    function isApprovedForAll(address account, address operator) public override(ERC1155, SmcPermission) view virtual returns (bool){
        return ERC1155.isApprovedForAll(account, operator);
    }
}