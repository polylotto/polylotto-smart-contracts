// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;
import "hardhat/console.sol";

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract faucet is Ownable{
    //faucet address = 0x0438A0893B38fc6fae79DaB21A09b14d96bE1115
    using SafeERC20 for IERC20;

    IERC20 public testToken;

    constructor(address _testTokenAddress){
        testToken = IERC20(_testTokenAddress);
    }

    function fundFaucet(uint256 _amount) public onlyOwner {
        testToken.safeTransferFrom(msg.sender, address(this), _amount);
    }


    function getTokens(address _destinationWallet) public {
        require(testToken.balanceOf(address(this)) > 1000*10**18, "Faucet Empty");
        testToken.safeTransfer(_destinationWallet, 1000*10**18);
    }

    function checkFaucetBalance() public view returns(uint256){
        return(testToken.balanceOf(address(this)));
    }
    
    function changeToken(address _newToken) public onlyOwner {
        testToken = IERC20(_newToken);
    }
}