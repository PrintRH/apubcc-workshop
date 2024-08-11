// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ApuToken.sol";

contract ApuBroker is Ownable {
  ApuToken public apuToken;
  uint256 public constant apuTokensPerEth = 1000;

  event BuyApuTokens(
    address indexed buyer, uint256 amountOfEth, uint256 amountOfApuTokens
  );
  event SellApuTokens(
    address indexed seller, uint256 amountOfApuTokens, uint256 amountOfEth
  );

  constructor(address tokenAddress) Ownable(address(this)) {
    apuToken = ApuToken(tokenAddress);
  }

  function buyApuTokens() public payable {
    address buyer = msg.sender;
    uint256 amountOfApuTokens = msg.value * apuTokensPerEth;
    require(msg.value > 0, "Insufficient ETH to buy APU tokens");
    apuToken.transfer(buyer, amountOfApuTokens);
    emit BuyApuTokens(buyer, msg.value, amountOfApuTokens);
  }

  function sellApuTokens(uint256 amountOfApuTokensToSell) public {
    uint256 amountOfEthToSeller = amountOfApuTokensToSell / apuTokensPerEth;
    // Check that seller (me) has more than zero tokens to sell
    require(amountOfApuTokensToSell > 0, "Insufficient APU tokens to sell");
    // Check if seller(me) has enough tokens to sell
    require(
      apuToken.balanceOf(msg.sender) >= amountOfApuTokensToSell,
      "Insufficient APU tokens to sell"
    );
    // Check if vendor has enough tokens to sell
    require(
      address(this).balance >= amountOfEthToSeller,
      "Insufficient liquidity in Vendor to perform sale"
    );

    bool success =
      apuToken.transferFrom(msg.sender, address(this), amountOfApuTokensToSell);
    require(success, "Failed to transfer token to vendor");
    payable(msg.sender).transfer(amountOfEthToSeller);
    emit SellApuTokens(msg.sender, amountOfApuTokensToSell, amountOfEthToSeller);
  }

  function getApuTokenBalance() public view returns (uint256) {
    return apuToken.balanceOf(address(this));
  }
}
