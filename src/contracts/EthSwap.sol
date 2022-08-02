// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange"; //state varialble
    Token public token;
    uint256 public rate = 100;

    event TokenPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    event TokenSold(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    //tell smart contract where the token contract is located

    constructor(Token _token) {
        token = _token;
    }

    function buyTokens() public payable {
        //Amount of Ethereum * Redemption rate
        uint256 tokenAmount = msg.value * rate;

        //require that EthSwap has enough tokens
        require((token.balanceOf(address(this)) >= tokenAmount));

        // Transfer tokens to the user
        token.transfer(msg.sender, tokenAmount);

        //emit an event
        emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint256 _amount) public {
        //user cant sell more tokens than they have
        require((token.balanceOf(msg.sender) >= _amount));

        //calculate the amount of Ether to redeem
        uint256 etherAmount = _amount / rate;

        //require that EthSwap has enough tokens
        require(address(this).balance >= etherAmount);

        //Perform sale
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(etherAmount);

        //Emit an event
        emit TokenSold(msg.sender, address(token), _amount, rate);
    }
}
