//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;



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
    
    event LeaseInitiated(address indexed lease);
    
    // Miner confirms lease acceptance and begins hosting
    function initiateLease() payable public{
        require (msg.sender == minerAddress, "Sender address not equal to minerAddress");
        
        // Pay the first fraction of payment
        (bool sent, bytes memory data) = minerAddress.call{value: msg.value}("");
        require(sent, "Failed to initiateLease at send Ether to miner:");
        emit LeaseInitiated(address(address(this)));
    }
    
    
    // Todo how to limit checkpoints from Miner to once every X minutes?
    function checkpoint() public {
        require (msg.sender == driverAddress, "Checkpoint caller address not equal to driver address");
    }
       
    receive() external payable {}
    fallback() external payable {}
}

contract MinerPool {
    
    struct Miner {
        address minerAddress;
        int8 minerReputation;
    }
    
    Miner[] minerStack;
    address[] activeLeases;
    
    
    event LeaseCreated(address indexed newLease, string message);
    event MinerRegistered();
    event MinerReputationReported();
    
    function registerNewMiner() public{
        // todo register message.sender
        minerStack.push(Miner(msg.sender, 0));
    }
    
    // Driver creates and assigns a lease to a miner
    function createLease(string memory _packageURL, address _miner, uint16 _duration) payable public {
        address newLease = address(new ComputeLease(_packageURL, msg.sender, _miner, _duration, address(this)));
        activeLeases.push(newLease);
        
        //(bool sent, bytes memory data) = newLease.call{value: msg.value}("");
        (bool sent, bytes memory data) = newLease.call{value: msg.value}("");
        require(sent, "Failed to send Ether. CallData:");
        emit LeaseCreated(address(newLease), "New lease created");
        
    }

    
    // ComputeLease reports change in miner reputation
    function reportMinerReputation() public{
        // The ComputeLease contract should report reputation positive if 
        // compute lease is fully paid and driver has positive outcome
    }
    
    
    
}