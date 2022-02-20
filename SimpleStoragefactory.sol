// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

contract SimpleStorageFactory {

    SimpleStorage[] public storagesList;

    function createSimpleStorage() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        storagesList.push(simpleStorage);
    }

    function sfStore(uint _simpleStorageIndex, uint _simpleStorageNumber) public {
        // Address
        // ABI
        SimpleStorage(address(storagesList[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfRetriveStorageDispaly(uint _simpleStorageIndex) public view returns(uint) {
        return SimpleStorage(address(storagesList[_simpleStorageIndex])).retrive();
    }
}