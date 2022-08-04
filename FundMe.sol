// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    mapping(address => uint256) public addressToFundAmount;

    function fund() public payable {
        uint256 minimumUSD = 1 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "SPEND MORE ETH DAMMIT!");
        addressToFundAmount[msg.sender] += msg.value;
    }

    function getDescription() public view returns (string memory) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.description();
    }

    function getPrice() public view returns (int) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData();
        return price * 10000000000;
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = uint256(getPrice());
        uint256 ethPriceInUSD = (ethAmount * ethPrice) / 1000000000000000000;
        return ethPriceInUSD;
    }

    function withdraw() public payable {
        address payable _to = payable(msg.sender);
        _to.transfer(address(this).balance);
    }
}
