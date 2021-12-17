//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ComputePool.sol";

contract ComputeLease {

    event LeaseStarted(address indexed lease, bytes data);
    event CheckpointSetAndPaid(address indexed lease, bytes data);
    event InsufficientFundsToContinue(address indexed lease, bytes data);
    event LeaseEndedInsufficientFunds(address indexed lease, bytes data);
    event LeaseEndedByDriver(address indexed lease, bytes data);

    enum Status {
        INITIATED, // Created but not yet started
        RUNNING,
        STOPPED
    }

    address payable public driverAddress;
    address payable public minerAddress;
    address constant public networkFeeAddress = 0x3e8411606Eb6D4587f6890541B80E7Ba41B92f9a;
    uint64 private pricePerTimeGWEI;
    Status public status;
    uint256 public lastCheckpointTime;
    string private containerStorageURL;
    string private containerRunningURL;
    uint256 private constant waitTime = 20 seconds;

    // address private minerPoolAddress;
    
    
    // Invoked by the Driver
    constructor(string memory _containerStorageURL, address payable _driver,  address payable _miner) payable {
        containerStorageURL = _containerStorageURL;
        minerAddress = _miner;
        driverAddress = _driver;    
        status = Status.INITIATED;
        lastCheckpointTime = block.timestamp;
        pricePerTimeGWEI = 26441; // Todo modify this in the future to be configurable
    }
    
    
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
        
        containerRunningURL;

        status = Status.RUNNING;
        emit LeaseStarted(address(this), data);
    }
    
    
    // Miner invokes checkpoint after waitTime has passed
    function minerCheckpoint() public {
        require (msg.sender == minerAddress, "Checkpoint caller address not equal to driver address");
        
        // Calculate the fraction of payment for the network
        uint256 networkFee = address(this).balance / 1000;
        // Calculate fraction of payment for the miner's pool?

        require (block.timestamp > lastCheckpointTime + waitTime, "Time since last checkpoint is less than expected wait time");
        
        
        if(address(this).balance > pricePerTimeGWEI + networkFee){
            (bool sent, ) = driverAddress.call{value: address(this).balance }("");
            require(sent, "Failed to send remaining gwei");
            emit LeaseEndedInsufficientFunds(address(this), "Contract has insufficient funds to continue");
        
        } else {
            // Pay the first fraction of payment to caller
            (bool sent, ) = minerAddress.call{value: pricePerTimeGWEI}("");
            require(sent, "Failed to initiateLease at send Ether to miner:");

            // Pay the first fraction of payment
            (sent, ) = networkFeeAddress.call{value: networkFee }("");
            require(sent, "Failed to send Ether to networkFeeAddress:");

            // Update the checkpoint time
            lastCheckpointTime = block.timestamp;
            emit CheckpointSetAndPaid(address(this), "Checkpoint time updated, miner and network paid"); 
        }
    }

    function driverEndLease() public {
        require (msg.sender == driverAddress, "Checkpoint caller address not equal to driver address");
        
        (bool sent, ) = driverAddress.call{value: address(this).balance }("");
        require(sent, "Failed to send Ether to networkFeeAddress:");
        
        // TODO: update miner and pool reputation
        emit LeaseEndedByDriver(address(this), "Lease ended by driver");
    }
       
    receive() external payable {}
    fallback() external payable {}
}