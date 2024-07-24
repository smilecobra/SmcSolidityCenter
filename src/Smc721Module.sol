// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721Burnable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {SmcPermission} from "./SmcPermission.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Smc721Module is ERC721, ERC721Burnable, SmcPermission {
    string private s_tokenUri;
    mapping(address => mapping (uint256 index => uint256 tokenId)) private s_addressToIds;

    constructor(string memory tokenUri) ERC721("Smc721", "Smc721") SmcPermission(msg.sender, msg.sender) {
        s_tokenUri = tokenUri;
    }

    function setTokenUri(string memory tokenUri) public onlyAuth{
        s_tokenUri = tokenUri;
    }

    function mint(address to, uint256 tokenId) public onlyAuth {
        addTokenToUser(to, tokenId);
        _safeMint(to, tokenId);
    }

    function centerBurn(address to, uint256 tokenId) public approveOrAuth(ownerOf(tokenId), _msgSender()){
        removeTokenFromUser(to, tokenId);
        _burn(tokenId);
    }

    function burn(uint256 tokenId) public override approveOrAuth(ownerOf(tokenId), _msgSender()){
        removeTokenFromUser(_msgSender(), tokenId);
        _burn(tokenId);
    }

    function addTokenToUser(address to, uint256 tokenId) private {
        s_addressToIds[to][balanceOf(to)] = tokenId;
    }

    function removeTokenFromUser(address to, uint256 tokenId) private{
        uint256 length = balanceOf(to);
        for(uint256 i = 0; i < length; i++){
            if(s_addressToIds[to][i] == tokenId){
                s_addressToIds[to][i] = s_addressToIds[to][length - 1];
                break;
            }
        }
        delete s_addressToIds[to][length - 1];
    }

    function tokenURI(uint256 tokenId) public override view returns(string memory){
        return string.concat(s_tokenUri, "/", Strings.toString(tokenId));
    }

    function tokensOf(address owner) public view returns(uint256[] memory){
        uint256 length = balanceOf(owner);
        uint256[] memory tokens = new uint256[](length);
        for(uint256 i = 0; i < length; i++){
            tokens[i] = s_addressToIds[owner][i];
        }
        return tokens;
    }

    function isApprovedForAll(address account, address operator) public override(ERC721, SmcPermission) view virtual returns (bool){
        return ERC721.isApprovedForAll(account, operator);
    }
}