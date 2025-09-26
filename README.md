# Tourism Escrow Smart Contract

## Overview
The **Tourism Escrow System** is a decentralized smart contract built to ensure **secure and transparent transactions** between tourists and service providers in the tourism sector.  

It is primarily designed for:
- Accommodation bookings (hotels, homestays, resorts)
- Tour guide services
- Local experiences and activities

However, the contract is written in a **general-purpose way**, meaning **any application that requires escrow services** (e.g., freelance platforms, marketplaces, event ticketing) can adopt it with **minimal changes**.

---

## Features
- **Escrow-based Payment Security**: Funds are locked in the smart contract until services are delivered or cancelled.  
- **Booking Management**: Each booking stores tourist, provider, amount, and status.  
- **Event Transparency**: All actions emit events (`BookingCreated`, `ServiceDelivered`, `BookingCancelled`, `PaymentReleased`) for easy tracking on-chain.  
- **Cross-Chain Compatible**: Designed to run on **Ethereum mainnet and testnets**, as well as **Layer 2 scaling solutions** and **other EVM-compatible chains**.

---

## Supported Chains
This contract is EVM-compatible, so it can run on any chain that supports Solidity smart contracts, including:

- **Ethereum** (Mainnet, Goerli, Sepolia)  
- **zkSync Era**  
- **Polygon**  
- **BNB Smart Chain (BSC)**  
- **Arbitrum**  
- **Optimism**  
- **Avalanche C-Chain**  
- **Fantom**  
- **Base**  
- **Scroll**  

…and many more EVM chains.

---

## Contract Structure
- `Booking`: Stores details of each booking (`tourist`, `provider`, `amount`, `status`).  
- `createBooking()`: Allows a tourist to create a booking and deposit funds.  
- `getBooking()`: Returns booking details by ID.  
- Events:
  - `BookingCreated`
  - `ServiceDelivered`
  - `BookingCancelled`
  - `PaymentReleased`

---

## Usage Flow
1. **Tourist** calls `createBooking()` with the provider address and payment.  
2. Funds are locked in the contract until service completion.  
3. After service delivery, funds can be released to the provider.  
4. If cancelled, funds are refunded to the tourist.  

*(Additional functions like `markDelivered`, `releasePayment`, `cancelBooking` can be extended on top of this base system.)*

---

## Deployment
### Prerequisites
- Node.js & npm/yarn  
- Hardhat / Foundry (for compilation and deployment)  
- A wallet like MetaMask  
- Testnet ETH/BNB/MATIC/zkETH for deployment

### Compile & Deploy with Hardhat
```bash
# install dependencies
npm install --save-dev hardhat

# compile
npx hardhat compile

# deploy
npx hardhat run scripts/deploy.js --network sepolia



