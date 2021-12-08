# Convoi
    
>“Enabling the Web 3.0 ecosystem to enjoy all the conveniences of modern Web 2.0 application development among a decentralized pool of compute”

## What is Convoi?
Overview: Convoi is an Ethereum smart contract based network of *miners* serving available compute capacity to users (Drivers) who wish to run containers on a fully decentralized network. Drivers initiate a smart contract with the chosen miner(s) to host their container workload for a specified time in exchange for a fee in ETH.  
  
Reputation: miner reputation is reported to the MinerPool at the end of a contract by the Driver to indicate whether their container was hosted successfully or not.  
  
Terminology:  
* Driver: a user who wishes to deploy their compute workload (website, forum, or any server side application) to the Convoi network
* Miner: a computer with available compute capacity that will host a package (container) in exchange for a fee
* Convoi Network: the list of all available miners with available compute capacity
* Package: a URL pointing to the container to be hosted  
  
## How to use Convoi?

### Driver: How to submit a package?
1. Save your container image to a publicly accessible URL (S3, Filecoin, Storj, etc.)
2. Navigate to the Driver front end at ...
3. Follow the instructions to submit your request to initiate the ComputeLease contract

### Miner: How to join the network and serve compute packages?
1. Navigate from this repository to Miner -> ...

