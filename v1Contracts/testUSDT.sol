// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract testUSDT is ERC20{ 

    constructor(uint256 _initialSupply) ERC20("testUSDT", "testUSDT") {
        _mint(msg.sender, _initialSupply *(10 ** decimals()));
    }
}
//npx hardhat verify --contract "contracts/testUSDT.sol:testUSDT" --network mumbai_testnet 0xe75613bc32e3ec430adbd46d8ddf44c2b7f82071 20000000