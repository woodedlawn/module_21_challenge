pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        // YOUR CODE HERE!
        uint256 rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        KaseiCoin token, // the KaseiCoin itself that the KaseiCoinCrowdsale will work with
        uint goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close // the crowdsale closing time
    ) public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    // YOUR CODE HERE!
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    // YOUR CODE HERE!
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(
       // YOUR CODE HERE!
       string memory name,
       string memory symbol,
       address payable wallet,
       uint goal
    ) public {
        // Create a new instance of the KaseiCoin contract.
        // YOUR CODE HERE!
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        // YOUR CODE HERE!
        kasei_token_address = address(token);
        
        // Create a new instance of the `KaseiCoinCrowdsale` contract
        // YOUR CODE HERE!
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale (1, wallet, token, goal, now, now + 24 weeks);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        // YOUR CODE HERE!
        kasei_crowdsale_address = address(kasei_crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        // YOUR CODE HERE!
        token.addMinter(kasei_crowdsale_address);
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        // YOUR CODE HERE!
        token.renounceMinter();
    }
}