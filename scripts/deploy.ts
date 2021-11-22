import { ethers } from "hardhat";

const main = async () => {
  const nftContractFactory = await ethers.getContractFactory("NFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  // let txn = await nftContract.make();

  // await txn.wait();
  // console.log("Minted 1: ", txn.hash);

  // txn = await nftContract.make();

  // await txn.wait();
  // console.log("Minted 2: ", txn.hash);
};

const runMain = async () => {
  try {
    await main();
    process.exitCode = 0;
  } catch (error) {
    console.error(error);
    process.exitCode = 1;
  }
};

runMain();
