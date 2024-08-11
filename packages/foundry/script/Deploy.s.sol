//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/ApuToken.sol";
import "../contracts/ApuBroker.sol";
import "./DeployHelpers.s.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DeployScript is ScaffoldETHDeploy {
  error InvalidPrivateKey(string);

  function run() external {
    uint256 deployerPrivateKey = setupLocalhostEnv();
    if (deployerPrivateKey == 0) {
      revert InvalidPrivateKey(
        "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
      );
    }
    vm.startBroadcast(deployerPrivateKey);

    ApuToken apuToken = new ApuToken();
    console.logString(
      string.concat("ApuToken deployed at: ", vm.toString(address(apuToken)))
    );

    ApuBroker apuBroker = new ApuBroker(address(apuToken));
    console.logString(
      string.concat("ApuBroker deployed at: ", vm.toString(address(apuBroker)))
    );
    apuToken.transfer(address(apuBroker), 1000000 ether);

    vm.stopBroadcast();

    /**
     * This function generates the file containing the contracts Abi definitions.
     * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
     * This function should be called last.
     */
    exportDeployments();
  }

  function test() public { }
}
