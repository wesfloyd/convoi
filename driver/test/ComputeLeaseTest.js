const { expect } = require("chai");
const { ethers } = require("hardhat");
const provider = waffle.provider;

describe("---ComputeLease Test Functions---\n\n", async function () {

    let driverSigner, minerSigner;
    let ComputeLeaseFactory;
    let ComputeLease;
    
    before(async function() {
        [driverSigner, minerSigner] = await ethers.getSigners();
        ComputeLeaseFactory = await ethers.getContractFactory("ComputeLease", driverSigner);
        ComputeLease = await ComputeLeaseFactory.deploy("defipulse.com", 
            driverSigner.address, minerSigner.address, { value: 100 });
        
        //console.log( "ComputeLease signer address: ", ComputeLease.signer.getAddress());
        //console.log( "driverSigner address: ", driverSigner.getAddress());
        //console.log( "minerSigner address: ", minerSigner.getAddress());
        
        console.log("Miner balance in gwei: ", 
            ethers.utils.formatUnits(await minerSigner.getBalance(), "ether"));
        console.log("Driver balance in gwei: ", 
            ethers.utils.formatUnits(await driverSigner.getBalance(), "ether"));
        console.log("ComputeLease contract balance in gwei: ", 
            ethers.utils.formatUnits(await provider.getBalance(ComputeLease.address), "ether"));
    })
    
    it("Validate the contract lease was created and deployed properly", async function () {

        expect(await ComputeLease.status() == 0);
        
        leaseBalance = parseInt(await provider.getBalance(ComputeLease.address));
        //console.log("Contract value: ", leaseBalance);
        expect(leaseBalance).to.equal(100);

        //console.log("Current time minus checkpoint time: ", String(await ComputeLease.lastCheckpointTime()));
        currentTime = new Date().getTime();
        //console.log("Now: ", currentTime );
        expect (String(await ComputeLease.lastCheckpointTime()) < currentTime);

        // TODO: add a check for the event via filter or otherwise
    });
    
    it("Miner accept lease", async function () {

        // call minerAcceptLease();
        
        console.log("Miner balance in gwei after: ", 
            ethers.utils.formatUnits(await minerSigner.getBalance(), "gwei"));
        console.log("Miner balance in eth after: ", 
            ethers.utils.formatUnits(await minerSigner.getBalance(), "ether"));


        
        //ComputeLease.minerAcceptLease() ...
        // TODO add an expect test to validate payments
        
    });

    it("Should accept lease, then checkpoint an existing lease, and a miner should get paid", async function () {
        
        
        // TODO calculate network and minerSigner balances before
        
        // Wait 20 seconds
        //this.timeout(20000);

        // TODO add an expect test to validate payments
        // Check balances after
        
    });


    it("miner should attempt to checkpoint twice in a row without waiting, which should fail");

    
});