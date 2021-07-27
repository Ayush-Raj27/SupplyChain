// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "./ItemManager.sol";

// This item contract work is to recieve the payment and hand it back to the Item Manager
contract Item{
    
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei , uint _index) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    receive() external payable{
        
        require(msg.value == priceInWei ," partial Payment is not Allowed!");
        require(pricePaid == 0 , "Item is already paid!");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index)); // it's a low level
                                                                                                                            // function call ..to send more gases..for further execution
        require(success , " Delivery did not work");
        
    }
    
    fallback() external{
        
    }
}

