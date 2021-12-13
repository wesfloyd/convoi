//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./MinerPool.sol";

contract ComputeLease {

    enum Status {
        INITIATED, // Created but not yet started
        RUNNING,
        STOPPED
    }

    address public driverAddress;
    address public minerAddress;
    string containerURL;
    uint16 pricePerHour; // in cents or $0.01
    Status public status;
    // address private minerPoolAddress;
    
    
    // Invoked by the Driver
    constructor(string memory _containerURL, address _driver, address _miner) {
        containerURL = _containerURL;
        minerAddress = _miner;
        driverAddress = _driver;    
        status = Status.INITIATED;
    }
    
    event LeaseInitiated(address indexed lease, bytes data);
    
    function getStatus() public view returns (Status) {
        return status;
    }

    // Miner confirms lease acceptance and begins hosting
    function minerAcceptLease() payable public{
        require (msg.sender == minerAddress, "Sender address not equal to minerAddress");
        
        // Pay the first fraction of payment
        (bool sent, bytes memory data) = minerAddress.call{value: msg.value}("");
        require(sent, "Failed to initiateLease at send Ether to miner:");
        
        status = Status.RUNNING;
        emit LeaseInitiated(address(this), data);
    }
    
    
    // Todo how to limit checkpoints from Miner to once every X minutes?
    function minerCheckpoint() view public {
        require (msg.sender == minerAddress, "Checkpoint caller address not equal to driver address");
        
        // TODO: perform checkpointing

    }

    function endLease() view public {
        require (msg.sender == driverAddress, "Checkpoint caller address not equal to driver address");
        

        // TODO: Return remaining funds to msg.sender


    }
       
    receive() external payable {}
    fallback() external payable {}
}