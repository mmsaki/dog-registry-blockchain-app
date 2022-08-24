# Dog Registry Blockchain Application

## Table of Contents
1. [Project Outline](#project-outline)
2. [Benefits of using our Dapp Vs Centralized registry application](#benefits-of-using-our-dapp-vs-centralized-registry-dog-applications)
3. [How our blockchain application works](#how-our-blockchain-application-works)
4. [Improvements or Updates or Features](#improvements-or-updates-or-features)

## Project Outline
The goal of our dog registration application is to increase the confidence of dog owners in the genetic history of their dogs while supporting responsible breeders, veterinarians, and sales agreements.

 The [American Kennel Club](https://www.akc.org/) has maintained a registry of pure breed dogs since 1884 as a means of maintaining the integrity of breed lineages and the integrity of those involved in dog breeding. The AKC is an advocate for pure breed dog ownership, canine health, and promotion of responsible dog ownership and breeding. Currently, the AKC maintains paper and electronic breed records that are held in central authority. Persons who wish to breed their dogs must pay fees to register the sire, the dame, and the resulting litter of puppies. Further fees are paid for registration of health, genetics, sale, and ownership. Each certification is held separately, fees are charged to access each record. See: https://www.akc.org/register/.
 
## Benefits of using our Dapp Vs. Centralized Registry Dog applications

The application that we have developed uses smart contracts and blockchain technology to verify and store dog registry data on a blockchain contract. 

Benefits of using a decentralized application (DAPP) compared to traditional dog registries: 
- Verify dog breed lineage easily
- Prevent fraud activities
- Improve transparancy
- Realtime accounting
- Cost reduction for registrations
- Imutability
- Decentralized ledger accessible to the public
- Increased trust in record keeping
- Programable sytstem

The registry dapp tracks a puppy from broker to new owner in a single, immortal, blockchain smart contract that is accessable to all key actors in the process. For each litter the blockchain record has relavent identities, certifications and information (Figure 1). The broker or kennel club, certifys a veterinarian, and buyer/ owner are also recorded along with the certifications given by each entity. 

This blockchain application introduces a heretofore unprecedented level of transparency to dog breeding and increases the confidence of dog owners in the veracity of breeding information while supporting responsible breeders, veterinarians, and brokers.

![Diagram](DogRegistryChain.png)

## How our blockchain application works

This application allows you to interact with a backend smart contract that has already been deployed.

### Step 1: Preparation steps for testing the dapp locally

1. Set up **Ganache** for a blockchain environment
2. Import ganache account to your metamask using the provided private keys
3. Import `DogNFT.sol` and `DogRegistry.sol` to Remix IDE 
4. Compile and Deploy `DogRegistry.sol`  using injected metamask on Remix
5. Copy the deployed smart contract address into your `.env` environment
6. Add pinata keys to `.env` file. 

> **Note**
Use SAMPLE.env file as a template and change the file name from `SAMPLE.env` to `.env` after adding your pinata keys and deployed contract address.

### Step 2: Running the application

Make sure you still have ganache open and running and proceed to run the `app.py` application. 

The application requires streamlit installed so if you don't have it installed, use `pip install streamlit` from your Terminal and then proceed.

Use terminal to `cd` into the `dog-registry-blockchain-app/` directory and use streamlit to run the `app.py` with the following command.

```
streamlit run app.py
```

### Step 3: Navigating through the app

Use the select accounts on the sidebar panel to select the account that will be executing function calls on the smart contract. 

## Improvements or Updates or Features

- Produce an NFT for the dogs.
    - The owner recieves a non-fungible token (NFT) unique to their new dog along with access to the breeding and health records.
    - We  have created an [NFT smart contract app](./dog-nft-app.py) but it has not been integreted to the dog registry system.