// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ApuToken is ERC20, Ownable {
  constructor() ERC20("ApuToken", "APU") Ownable(msg.sender) {
    _mint(msg.sender, 1000000 * 10 ** decimals());
  }
}
