const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("---ComputeLease Test Functions---\n\n", function () {

    before(function() {
        // runs once before the first test in this block
        const [driver, miner] = await ethers.getSigners();
        const ComputeLeaseFactory = await ethers.getContractFactory("ComputeLease");
        const ComputeLease = await ComputeLeaseFactory.deploy("defipulse.com", 
            driver.address, miner.address);
      })
    
    it("Should create a compute lease and deploy it", async function () {

        
    
        //console.log("Computelease status: ", await ComputeLease.status());
        
        expect(await ComputeLease.status().to.equal(0));
        //expect(await ComputeLease.getStatus().to.equal(0));
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