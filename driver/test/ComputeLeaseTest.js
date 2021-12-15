const { expect } = require("chai");
const { ethers } = require("hardhat");
const provider = waffle.provider;

describe("---ComputeLease Test Functions---\n\n", async function () {

    let driver, miner;
    let ComputeLeaseFactory;
    let ComputeLease;

    before(async function() {
        [driver, miner] = await ethers.getSigners();
        ComputeLeaseFactory = await ethers.getContractFactory("ComputeLease");
        ComputeLease = await ComputeLeaseFactory.deploy("defipulse.com", 
            driver.address, miner.address, { value: 100 });
    })
    
    it("Should validate the contract lease was created and deployed properly", async function () {

        expect(await ComputeLease.status() == 0);
        
        console.log("Contract value: ", String(await provider.getBalance(ComputeLease.address)));
        //expect(await ComputeLease.value.to.equal(100);

        //console.log("Last checkpoint time: ", String(await ComputeLease.lastCheckpointTime()));
        //console.log("Now: ", new Date().getTime() );
        // Todo add test for checkpoint time

    });
    
    it("Miner accept lease", async function () {


        // TODO add an expect test to validate payments
        
    });

    it("Should checkpoint an existing lease a compute lease and miner should get paid", async function () {
        
        // Wait 20 seconds
        this.timeout(20000);

        // TODO calculate network and miner balances before

        ComputeLease.minerCheckpoint();

        // TODO add an expect test to validate payments
        // Check balances after
        
    });


    /**
    // Connect in order to pay?
    await ComputeLease.minerAcceptLease(...);
    expect(await ComputeLease.status().to.equal(50);

    minerCheckpoint
    await ComputeLease.initiateLease(...);
    expect(await ComputeLease.status().to.equal(50);

    ...


    // Transfer 50 tokens from owner to addr1
    await hardhatToken.transfer(addr1.address, 50);
    expect(await hardhatToken.balanceOf(addr1.address)).to.equal(50);

    // Transfer 50 tokens from owner to addr1
    await hardhatToken.transfer(addr1.address, 50);
    expect(await hardhatToken.balanceOf(addr1.address)).to.equal(50);

    // Transfer 50 tokens from addr1 to addr2
    await hardhatToken.connect(addr1).transfer(addr2.address, 50);
    expect(await hardhatToken.balanceOf(addr2.address)).to.equal(50);
    */


    
});