# PolyLotto Smart Contracts

This repo contains the smart contracts of the Polylotto raffle


## Polygon Mainnet
PolyLotto Raffle Contract: [link](https://polygonscan.com/address/0x9267e9fe6148bf1226a8b9c038262672a57d6c5a#code)

PolyLotto Keeper Contract: [link](https://polygonscan.com/address/0xdc130f831d66dd083f23e49b80b890eecf7ba42c#code)

PolyLotto Random Generator Contract: [link](https://polygonscan.com/address/0x92f3915d158fdca4b526a4f5e2bc4314f2ee65cd#code)

PolyLotto PriceUpdater Contract: [link](https://polygonscan.com/address/0x6689e480f7b9b775091c812df76bac8b90456d46#code)

## Mumbai Testnet
PolyLotto Raffle Contract: [link](https://mumbai.polygonscan.com/address/0x99fbc7dd5354187b23c538fd2e477a084286a47b#code)

PolyLotto Keeper Contract: [link](https://mumbai.polygonscan.com/address/0x7acdc61b41103f12a9db9ec032e9c772aa90435d#code)

PolyLotto Random Generator Contract: [link](https://mumbai.polygonscan.com/address/0xf13c7d6c69f5f32c3bbb99c67f0c0866db7bd9f4#code)

PolyLotto PriceUpdater Contract: [link](https://mumbai.polygonscan.com/address/0x9b78a729cd10b29d37da5bf151036d4d3bca4db9#code)

PolyLotto Faucet Contract: [link](https://mumbai.polygonscan.com/address/0xcef1e15db4a759b394e017c54322cf00461e1fa9#code)




# Contract Parameters
    Create three Raffle categories
    Basic category -- $1
    Investor category -- $10
    Whale category -- $100

    Duration -- Every 2 days
    For testnet every 3 hour
    For testnet payout happens every 1 hour

    Payouts -- Automatically
    Contract gets -- 50%
    1 Winner -- 25%
    2 Winner -- 15%
    3 Winner -- 10%

    Odds of Winning is increased by the number of tickets a person buys, but it does not guarantee winning,
    as the randomness is generated randomly using the chainlink vrf and not with any existing variable in the contract

    Users are given indexes for each ticket bought, a mapping to store the each user to a ticket id.
    So after the raffle is drawn lucky index number for raffle is chosen and the winners are awarded
    Since there are 3 winners raffles will be drawn thrice.
    first winner is the first person 25%
    second is the 2nd person 15%
    third is the 3rd person 10%
    This is done by using the keccak function to alter the random value gotten from the vrf request.

    The random values gotten for each Raffle are just basically indexes which are then looked up in the user-ticket mapping

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
```
