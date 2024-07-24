// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Test, console} from "forge-std/Test.sol";

interface IMintableERC721 is IERC721 {
    function mint(address to, uint256 tokenId) external;
    function centerBurn(address to, uint256 tokenId) external;
}

interface IMintableERC1155 is IERC1155 {
    function mint(address to, uint256 tokenId, uint256 value, bytes memory data) external;
    function mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) external;
    function burn(address to, uint256 tokenId, uint256 value) external;
    function burnBatch(address to, uint256[] memory ids, uint256[] memory values) external;
}

struct Mint1155 {
    address contractAddress;
    uint256[] tokenIds;
    uint256[] values;
}

contract SmcCenter is Ownable{
    error InvalidInput();

    address[] private _contract1155s;

    constructor(address initialOwner) Ownable(initialOwner) {}

    function mint(address to, address[] memory contracts, uint256[] memory types, uint256[] memory tokenIds, uint256[] memory values) public onlyOwner{
        if(contracts.length != types.length || contracts.length != tokenIds.length || contracts.length != values.length){
            revert InvalidInput();
        }

        for(uint i = 0; i < contracts.length; i++){
            if(types[i] == 721){
                IMintableERC721(contracts[i]).mint(to, tokenIds[i]);
                continue;
            }
            if(types[i] == 1155){
                if(inContracts1155(contracts[i])){
                    continue;
                }
                _contract1155s.push(contracts[i]);
                uint256 length = contracts.length - i;
                uint256[] memory _tokenIds = new uint256[](length);
                uint256[] memory _values = new uint256[](length);
                uint256 z = 0;
                for(uint j = i; j < contracts.length; j++){
                    if(contracts[j] != contracts[i]){
                        continue;
                    }
                    _tokenIds[z] = tokenIds[j];
                    _values[z] = values[j];
                    z ++;
                }
                if(z == 1)
                    IMintableERC1155(contracts[i]).mint(to, _tokenIds[0], _values[0], '0X');
                else
                    IMintableERC1155(contracts[i]).mintBatch(to, _tokenIds, _values, '0X');
                continue;
            }
        }

        _contract1155s = new address[](0);
    }

    function burn(address to, address[] memory contracts, uint256[] memory types, uint256[] memory tokenIds, uint256[] memory values) public onlyOwner{
        if(contracts.length != types.length || contracts.length != tokenIds.length || contracts.length != values.length){
            revert InvalidInput();
        }

        for(uint i = 0; i < contracts.length; i++){
            if(types[i] == 721){
                IMintableERC721(contracts[i]).centerBurn(to, tokenIds[i]);
                continue;
            }
            if(types[i] == 1155){
                if(inContracts1155(contracts[i])){
                    continue;
                }
                _contract1155s.push(contracts[i]);
                uint256 length = contracts.length - i;
                uint256[] memory _tokenIds = new uint256[](length);
                uint256[] memory _values = new uint256[](length);
                uint256 z = 0;
                for(uint j = i; j < contracts.length; j++){
                    if(contracts[j] != contracts[i]){
                        continue;
                    }
                    _tokenIds[z] = tokenIds[j];
                    _values[z] = values[j];
                    z ++;
                }
                if(z == 1)
                    IMintableERC1155(contracts[i]).burn(to, _tokenIds[0], _values[0]);
                else
                    IMintableERC1155(contracts[i]).burnBatch(to, _tokenIds, _values);
                continue;
            }
        }

        _contract1155s = new address[](0);
    }

    function burnMint(
        address to, 
        address[] memory mintContracts, 
        uint256[] memory mintTypes, 
        uint256[] memory mintTokenIds, 
        uint256[] memory mintValues,
        address[] memory burnContracts, 
        uint256[] memory burnTypes, 
        uint256[] memory burnTokenIds, 
        uint256[] memory burnValues
    ) public onlyOwner
    {
        burn(to, burnContracts, burnTypes, burnTokenIds, burnValues);
        mint(to, mintContracts, mintTypes, mintTokenIds, mintValues);
    }


    function inContracts1155(address search) private view returns(bool s){
        s = false;
        for(uint i = 0; i < _contract1155s.length; i++){
            if(_contract1155s[i] == search){
                s = true;
                break;
            }
        }
        return s;
    }
}