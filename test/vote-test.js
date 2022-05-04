const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const assert = require('assert');



describe("VOte", function () {
  let signers;
  let owner;
  let vote;
  let Vote;

  beforeEach(async function () {
      Vote = await ethers.getContractFactory("Vote");
      vote = await Vote.deploy(prizeAmount);
      await vote.deployed();
      signers = await ethers.getSigners();
      owner = signers[0];
      player = signers[1];
      player2 = signers[2];
  });


    it("test_addCandidator", async function () {
  
      const addCandidatorTx = await vote.addCandidator("xxx");
  
      // wait until the transaction is mined
      await addCandidatorTx.wait();

    });


    //it('ERC721Metadata: URI query for nonexistent token', async () => {

        //try{
       //await wrapper.tokenURI(1)({
        //from: signers[0]
            //});
            //assert(false);
        //} catch(err){
            //assert(err);
        //}
      //});
});