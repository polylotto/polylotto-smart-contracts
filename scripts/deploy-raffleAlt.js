// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const {BigNumber} = require("ethers");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const vrfCoordinator = "0x8C7382F9D8f56b33781fE506E897a4F1e2d17255";
  const linkToken = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
  const keyhash = "0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4";
  const fee = BigNumber.from('10').pow(14).toString();
  const TokenAddress = "0xe75613bc32e3ec430aDbD46D8dDf44C2b7F82071"

  const Raffle = await hre.ethers.getContractFactory("RaffleAlt");
  const raffle = await Raffle.deploy(vrfCoordinator, linkToken, keyhash, fee, TokenAddress);
  await raffle.deployed();

  console.log("Deployed to:", raffle.address);
  //npx hardhat verify --contract "contracts/testUSDT.sol:testUSDT" --network mumbai_testnet 0xe75613bc32e3ec430adbd46d8ddf44c2b7f82071 20000000
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
