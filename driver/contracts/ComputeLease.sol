//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ComputePool.sol";

contract ComputeLease {

    enum Status {
        INITIATED, // Created but not yet started
        RUNNING,
        STOPPED
    }

    address public driverAddress;
    address public minerAddress;
    address constant public networkFeeAddress = 0x3e8411606Eb6D4587f6890541B80E7Ba41B92f9a;
    string containerURL;
    uint64 private pricePerHourGWEI;
    Status public status;
    uint256 public lastCheckpointTime;
    uint256 private constant waitTime = 20 seconds;

    // address private minerPoolAddress;
    
    
    // Invoked by the Driver
    constructor(string memory _containerURL, address _driver, address _miner) {
        containerURL = _containerURL;
        minerAddress = _miner;
        driverAddress = _driver;    
        status = Status.INITIATED;
        lastCheckpointTime = block.timestamp;
        pricePerHourGWEI = 26441; // Todo modify this in the future to be configurable
    }
    
    event LeaseStarted(address indexed lease, bytes data);
    event CheckpointSetAndPaid(address indexed lease, bytes data);
    event InsufficientFundsToContinue(address indexed lease, bytes data);

    function getStatus() public view returns (Status) {
        return status;
    }
    
    function getLastCheckpointTime() public view returns (uint256){
        return lastCheckpointTime;
    }

    // Miner confirms lease acceptance and begins hosting
    function minerAcceptLease() payable public{
        require (msg.sender == minerAddress, "Sender address not equal to minerAddress");
        
        // Pay the first fraction of payment
        (bool sent, bytes memory data) = minerAddress.call{value: msg.value}("");
        require(sent, "Failed to initiateLease at send Ether to miner:");
        
        status = Status.RUNNING;
        emit LeaseStarted(address(this), data);
    }
    
    
    // Todo how to limit checkpoints from Miner to once every X minutes?
    function minerCheckpoint() public {
        require (msg.sender == minerAddress, "Checkpoint caller address not equal to driver address");
        
        // Calculate the fraction of payment
        uint256 networkFee = address(this).balance / 1000;

        require (block.timestamp > lastCheckpointTime + waitTime, "Time since last checkpoint is less than expected wait time");
        require (address(this).balance > pricePerHourGWEI + networkFee, "Contract has insufficient funds to continue");
    
        // Pay the first fraction of payment to caller
        (bool sent, ) = minerAddress.call{value: pricePerHourGWEI}("");
        require(sent, "Failed to initiateLease at send Ether to miner:");

        // Pay the first fraction of payment
        (sent, ) = networkFeeAddress.call{value: networkFee }("");
        require(sent, "Failed to send Ether to networkFeeAddress:");

        // Update the checkpoint time
        lastCheckpointTime = block.timestamp;
        emit CheckpointSetAndPaid(address(this), "Checkpoint time updated, miner and network paid");
        
    }

    function endLease() public {
        require (msg.sender == driverAddress, "Checkpoint caller address not equal to driver address");
        
        // TODO: Return remaining funds to msg.sender
        // Pay the first fraction of payment
        (bool sent, ) = driverAddress.call{value: address(this).balance }("");
        require(sent, "Failed to send Ether to networkFeeAddress:");

    }
       
    receive() external payable {}
    fallback() external payable {}
}