# NFT Collection

Built as part of the run through around Ethereum, Solidity and shipping that stuff on Buildspace!

## Initialisation

- Copy the env.example file to .env and fill in the relevant details
-- We used Alchemy for the Rinkeby testnet clone to work with
-- The private key is the account you want to mint with
- `npm i` that goodness

## Running it

- `npx hardhat run scripts/run.ts`
-- This will be for local testing within hardhat. The script can be rejigged for what you need to do. It currently mints a single NFT.
- `npx hardhat run scripts/deploy.ts`
-- This will deploy the current smart contracts (alongside compiling them) to the Rinkeby testnet that we have set up.

### Todo

- Improved UI and personal styling
- Show the currently connected wallets minted NFTs on the main page
- Limit the total supply of the NFT
