//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ComputeLease.sol";

contract MinerPool {
    
    struct Miner {
        address minerAddress;
        int8 minerReputation;
    }
    
    mapping(address => Miner) public minerStack;
    
    mapping(address => ComputeLease) public activeLeases;
    
    
    event LeaseCreated(address indexed newLease, bytes data);
    event MinerRegistered();
    event MinerReputationReported();
    
    function registerNewMiner() public{
        // todo register message.sender
        minerStack[msg.sender] =  Miner(msg.sender, 0);
    }
    
    // Driver creates and assigns a lease to a miner
    function createLease(string memory _packageURL, address _miner, uint16 _duration) payable public {
        ComputeLease newLease = new ComputeLease(_packageURL, msg.sender, _miner, _duration, address(this));
        activeLeases[address(newLease)] = newLease;
        
        //(bool sent, bytes memory data) = newLease.call{value: msg.value}("");
        (bool sent, bytes memory data) = address(newLease).call{value: msg.value}("");
        require(sent, "Failed to send Ether. CallData:");
        
        emit LeaseCreated(address(newLease), data);
    }

    
    // ComputeLease reports change in miner reputation
    function reportMinerReputation(address _miner, bool positive) public{
        // The ComputeLease contract should report reputation positive if 
        // compute lease is fully paid and driver has positive outcome
        if (positive)
            minerStack[_miner].minerReputation += 1;
        else minerStack[_miner].minerReputation -= 1;
    }
    
    
    
}