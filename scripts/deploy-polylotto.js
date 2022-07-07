// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { BigNumber } = require("ethers");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const vrfCoordinator = "0x3d2341ADb2D31f1c5530cDC622016af293177AE0";
  const linkToken = "0xb0897686c545045aFc77CF20eC7A532E3120E0F1";
  const TokenAddress = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
  const StableTokenAddress = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063";
  const StableTokenName = "DAI";
  const amountOfTokenPerDai = BigNumber.from("10").pow(6).toString();

  // Deploy Raffle Contract
  console.log("Getting Contract.....");
  const Raffle = await hre.ethers.getContractFactory("PolylottoRaffle");
  const raffle = await Raffle.deploy(TokenAddress, amountOfTokenPerDai);
  console.log("Deploying.....");
  await raffle.deployed();
  console.log("Deployed to:", raffle.address);

  //Deploy Random Generator
  console.log("Getting Generator Contract.....");
  const RandomGen = await hre.ethers.getContractFactory(
    "RandomNumberGenerator"
  );
  const randomGen = await RandomGen.deploy(vrfCoordinator, linkToken);
  console.log("Deploying...");
  await randomGen.deployed();
  console.log("Generator deployed to: ", randomGen.address);

  // Deploy Keeper Contract
  console.log("Getting Keeper Contract.....");
  const Keeper = await hre.ethers.getContractFactory("PolylottoKeeper");
  const keeper = await Keeper.deploy(randomGen.address, raffle.address);
  console.log("Deploying.....");
  await keeper.deployed();
  console.log("Keeper deployed to: ", keeper.address);

  // Deploy Price Updater Contract
  console.log("Getting Price Updater Contract.....");
  const PriceUpdater = await hre.ethers.getContractFactory(
    "PolyLottoPriceUpdater"
  );
  const priceUpdater = await PriceUpdater.deploy(
    TokenAddress,
    StableTokenAddress,
    StableTokenName
  );
  console.log("Deploying.....");
  await priceUpdater.deployed();
  console.log("Price Updater deployed to: ", priceUpdater.address);
}

//npx hardhat verify --network mumbai_testnet

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
