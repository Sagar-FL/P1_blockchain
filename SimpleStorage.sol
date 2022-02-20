// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {
    uint storageDisplayNumber;

    struct People {
        string name;
        uint favNumber;
    }

    People[] public people;
    mapping(string => uint) public favNumberMap;

    function store(uint _displayNumber) public {
        storageDisplayNumber = _displayNumber;
    }

    function retrive() public view returns(uint) {
        return storageDisplayNumber;
    }

    function addPerson(string memory _name, uint _favNumber) public {
        people.push(People(_name, _favNumber));
        favNumberMap[_name] = _favNumber;
    }
}