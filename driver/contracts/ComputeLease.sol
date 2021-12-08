//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./MinerPool.sol";

contract ComputeLease {
     
    uint16 durationMins;
    uint256 containerID;
    address driverAddress;
    address minerAddress;
    address minerPoolAddress;
    string containerURL;
    
    constructor(string memory _containerURL, address _driver, address _miner, 
        uint16 _duration, address _minerPool) {
        containerURL = _containerURL;
        minerAddress = _miner;
        durationMins = _duration;
        driverAddress = _driver;
        minerPoolAddress = _minerPool;
    }
    
    event LeaseInitiated(address indexed lease, bytes data);
    
    // Miner confirms lease acceptance and begins hosting
    function initiateLease() payable public{
        require (msg.sender == minerAddress, "Sender address not equal to minerAddress");
        
        // Pay the first fraction of payment
        (bool sent, bytes memory data) = minerAddress.call{value: msg.value}("");
        require(sent, "Failed to initiateLease at send Ether to miner:");
        
        emit LeaseInitiated(address(this), data);
    }
    
    
    // Todo how to limit checkpoints from Miner to once every X minutes?
    function minerCheckpoint() view public {
        require (msg.sender == driverAddress, "Checkpoint caller address not equal to driver address");
        
        // TODO: perform checkpointing

    }
       
    receive() external payable {}
    fallback() external payable {}
}