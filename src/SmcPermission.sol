// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";

abstract contract SmcPermission is Context {
    error UnauthorizedAccount(address account);
    error InvalidAddressForAuth(address account);
    error UnApproved(address account,address operator);

    address private _owner;
    address private _operator;

    constructor(address initialOwner, address initialOperator){
        _owner = initialOwner;
        _operator = initialOperator;
    }

    modifier onlyAuth(){
        _checkBoth();
        _;
    }

    modifier onlyOwner(){
        _checkOwner();
        _;
    }

    modifier approveOrAuth(address account, address opera){
        if (!isApproveOrAuth(account, opera)) {
            revert UnApproved(account, opera);
        }
        _;
    }

    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert UnauthorizedAccount(_msgSender());
        }
    }

    function _checkBoth() internal view virtual {
        if (owner() != _msgSender() && operator() != _msgSender()) {
            revert UnauthorizedAccount(_msgSender());
        }
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function operator() public view virtual returns (address) {
        return _operator;
    }

    function setOperator(address newOperator) public onlyOwner{
        if (newOperator == address(0)) {
            revert InvalidAddressForAuth(address(0));
        }
        _operator = newOperator;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert InvalidAddressForAuth(address(0));
        }
        _owner = newOwner;
    }

    function isApproveOrAuth(address account, address opera) public view virtual returns (bool){
        return opera == _owner || opera == _operator || isApprovedForAll(account, opera);
    }

    function isApprovedForAll(address, address) public view virtual returns(bool);
}