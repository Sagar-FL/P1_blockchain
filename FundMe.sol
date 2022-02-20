// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
    // eth -> usd test faucet
    address kovanPriceFeed =  0x9326BFA02ADD2366b30bacB125260Af641031331;
    address public owner;

    mapping(address => uint256) public address_to_amount_funded;
    address[] funders;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 minUSD = 50 * 10**18;
        require(getConversionRate(msg.value) >= minUSD, "You should spend more ETH");
        address_to_amount_funded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(kovanPriceFeed);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(kovanPriceFeed);
        (uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound) = priceFeed.latestRoundData();
        return uint256(answer * 10**10);
    }

    function getConversionRate(uint256 _ethAmt) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = _ethAmt * ethPrice / 10 ** 18;
        return ethAmountInUsd;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You should not do this");
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);

        for (uint256 index=0; index<funders.length; index++) {
            address funder = funders[index];
            address_to_amount_funded[funder] = 0;
        }
        funders = new address[](0);
    }
}