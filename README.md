# BASIC MULTI TOKEN ERC-1155

This simple project is an example of [ERC-1155 Standard](https://eips.ethereum.org/EIPS/eip-1155) implementation.

## :speech_balloon: Description

<p align="justify">A token standard defines the smart contract and features that the token issued by it has. There are many different standards on different blockchains. The simplest categorization would be between fungible and non-fungible tokens.</p>
<p align="justify">ERC-1155 is a widely adopted standard for fungible and non-fungible tokens on the Ethereum blockchain. It was proposed as an improvement to the ERC-20 and ERC-721 standards, combining the functionalities of both into a single standard.</p>

This implementation was created using the [Remix](https://remix.ethereum.org/) online code editor.

<div align="center">
  <kbd>
    <img src="/remix-multitoken-code.png" />
  </kbd>
</div>

### 🛠️ Features

These are the key features of an ERC-1155 smart contract:

- Fungible and Non-Fungible Tokens (NFTs): ERC-1155 allows a smart contract to create both fungible tokens (similar to ERC-20 tokens) and non-fungible tokens (similar to ERC-721 tokens) within the same contract. This means that a single contract can manage various token types.
- Batch Token Transfers: ERC-1155 supports batch transfers, enabling users to send multiple tokens in a single transaction. This feature is efficient for game developers and applications that require handling multiple assets at once.
- Single Contract Deployment for Multiple Tokens: With ERC-1155, multiple token types can be deployed within a single smart contract. This optimizes gas costs and reduces the number of smart contracts on the blockchain.
- Metadata Management: The standard allows for token metadata management, including optional metadata extension interfaces such as ERC-1155 Metadata URI and ERC-1155 Metadata URI JSON Schema. This enables better organization and display of token-related information.
- Atomic Swaps: ERC-1155 tokens support atomic swaps, meaning that multiple tokens can be transferred simultaneously in a single transaction. This ensures that either all the specified tokens are transferred, or none of them are transferred, preventing partial transfers or discrepancies.
- Approval for All: ERC-1155 includes an "Approval For All" function, allowing users to give approval to another address to transfer any of their tokens on their behalf. This simplifies interactions between users and applications.
- Enumeration and Balance Checks: ERC-1155 defines functions to retrieve the number of token types in existence (totalSupply) and an individual's balance of a particular token type (balanceOf). This is useful for user interfaces and applications to display token information accurately.
- Metadata URI Standardization: ERC-1155 introduces standards for token metadata URIs, providing consistency in the way metadata is stored and accessed for different tokens. This improves the user experience and compatibility between different applications.

### 🏗️ Built With

- Solidity

## Getting started

### 📋 Prerequisites

- Wallet address in an EVM compatible chain
- Balance to deploy the Smart Contract

### :arrow_down: Install

Not applicable.

### :gear: Configuration

Adjust the `currentSupply` with the maximum supply of your token and `tokenPrice` with the price value as desired.

```solidity
    // Multi-Token Identifiers (MTI): one identifier for each diferent token
    uint256 private constant MTI_1 = 0;
    uint256 private constant MTI_2 = 1;
    uint256 private constant MTI_3 = 2;

    // Supply control
    uint256[] public currentSupply = [50, 50, 50];

    // Token price
    uint256 public tokenPrice = 0.01 ether;
```
After create the [Metadata URI JSON Schema](https://eips.ethereum.org/EIPS/eip-1155#metadata), adjust your URI Metadata address in this function.

```solidity
    // ERC1155Metadata_URI Implementation

    function uri(uint256 _id) external pure returns (string memory) {

        require(_id < 3, "This token does not exists");

        // Replace the "ipfs://hashaddresstoyoururi/" for your own URI Address
        // If you don't use the ID and the .json sufix, change them too before deploy your contract 
        return string.concat("ipfs://hashaddresstoyoururi/", Strings.toString(_id),".json");
    }
```

### 👷 Deploy

To deploy your ERC-1155 smart contract follow these steps:

1. Copy the smart contract code
2. Open the [Remix IDE](https://remix.ethereum.org/)
  - On the left-hand side, you'll see the file explorer
  - Right-click and select "Create File" to create a new file for your smart contract
  - Give it a name and .sol extension, which indicates it's a Solidity smart contract file
3. In the new file created, paste your Solidity smart contract code copyed
4. Compile the contract by clicking on "Compile <file>" at the "Solidity Compiler" tab on left-hand side
5. Connect Remix to MetaMask (or any compatible Ethereum or testnet wallet) by clicking the "Connect to a Web3 Provider" button
6. Follow the instructions to connect your wallet
7. After connecting your wallet, select the desired network from the drop-down list
8. Click the "Deploy" button next to your contract name
9. After a MetaMask (or wallet) pop-up appear, asking you to confirm the contract deployment transaction, review the gas fees and click "Confirm" to proceed
10. Once the transaction is confirmed, you'll receive a transaction hash, indicating that your contract deployment transaction has been mined and included in a block

### 👨‍💻 Testing

Testing smart contracts with Remix IDE is straightforward and can be done using the Remix's built-in testing environment. Remix provides a simple way to write and execute unit tests for your smart contracts. Here's how you can test your smart contract using Remix:

1. Create a Test File: In the Remix IDE, on the left-hand side, right-click and select "Create File" to create a new file for your test script. Give it a .test.sol extension, which indicates it's a test file.
2. Write Test Cases: In the test file, write your test cases using Solidity code. Test cases are functions that test various aspects of your smart contract to ensure its functionality is correct. For example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "remix_tests.sol"; // Import the Remix testing library

contract HelloWorldTest {
    HelloWorld contractToTest;

    // This function will be executed before each test
    function beforeEach() public {
        contractToTest = new HelloWorld();
    }

    function testInitialMessage() public {
        string memory expectedMessage = "Hello, World!";
        Assert.equal(contractToTest.message(), expectedMessage, "Initial message is incorrect");
    }

    function testUpdateMessage() public {
        string memory newMessage = "Hello, Remix!";
        contractToTest.updateMessage(newMessage);
        Assert.equal(contractToTest.message(), newMessage, "Message not updated correctly");
    }
}
```
4. Compile the Test File: Remix will automatically compile your test file. To verify that there are no syntax errors in your tests, go to the "Solidity Compiler" tab on the right-hand side. Click on "Compile HelloWorldTest.test.sol" (or the name of your test file) to compile the code.
5. Run the Tests: After compiling, go to the "Test" tab on the right-hand side. You will see a "Test Explorer" panel displaying your test contract and its functions. Click the "Run" button next to your test contract name. Remix will execute all the test functions in your test contract.
6. View Test Results: After running the tests, the "Test Explorer" panel will show the results of each test. Green checkmarks indicate successful tests, while red crosses indicate failed tests. You can expand the test functions to see more detailed information about the test results.

### :arrow_forward: Usage

1. By Remix IDE

- Open the "Deployed Contracts" Section: After deploying the contract, go to the "Deploy & Run Transactions" section in Remix IDE.
- Select the Contract and Network: In the "Deployed Contracts" section, you will see a list of deployed contracts along with their addresses and ABIs (Application Binary Interface). Choose the contract you want to interact with from the dropdown menu labeled "At Address."
- Connect to the Contract: Click the "At Address" button. Remix will connect to the deployed contract at the given address, and you will see the contract's functions and state variables listed below.
- Interact with Functions: In the "Deployed Contracts" section, you can interact with the functions of your smart contract by providing the required parameters and clicking the "transact" button. If the function is a view function (read-only, without modifying the blockchain state), you can click the "call" button. When you interact with a function, Remix will ask you to confirm the transaction using your connected Ethereum wallet (e.g., MetaMask).
- Read State Variables: You can read the state variables of the contract by clicking on their names in the "Deployed Contracts" section. Remix will execute a read-only call to retrieve the current value of the state variable.
- Listen to Events: If your smart contract emits events, you can listen to them in the "Deployed Contracts" section. Click the "Events" button, and you'll be able to see the emitted events along with their details.
- View Transaction History: In the "Deployed Contracts" section, you can see the transaction history for the selected contract. It shows all the previous transactions, including their status and gas costs.

2. By your chain's block explorer

- Find the Contract Address: First, you need to know the address of the deployed smart contract. This address is a hexadecimal string (e.g., 0x123abc...) and serves as the unique identifier for the contract on the blockchain.
- Open the Block Explorer: Choose a blockchain block explorer that supports the network where your contract is deployed. Examples of popular block explorers are Etherscan for Ethereum and BscScan for Binance Smart Chain. Go to the website of the block explorer you want to use.
- Search for the Contract Address: In the search bar of the block explorer, enter the contract address you want to interact with and click "Search" or a similar button. The block explorer will display the contract's details, including its code, transactions, and events.
- Interacting with Functions: If the smart contract has public functions that can be called, the block explorer might provide a user interface to interact with those functions. You may need to look for a "Read Contract" or "Write Contract" section. In some block explorers, this feature is available in the "Contract" or "Smart Contract" tab.
  - Read Functions: For read-only functions (functions that don't modify the state), you can call them directly from the block explorer's interface, and it will display the returned value.
  - Write Functions: To interact with write functions (functions that modify the state), you will need to provide the necessary parameters and possibly your wallet's signature for authentication. After filling in the required details, submit the transaction.
- Transaction Confirmation: When you send a transaction to the contract, the block explorer will provide a transaction hash. You can use this hash to track the status of the transaction on the blockchain. It may take some time for the transaction to be mined and confirmed by the network.
- View Transaction History and Events: The block explorer will also show the transaction history of the contract, including all past interactions. Additionally, if the contract emits events, you can find and explore those events in the block explorer to see the details of each event occurrence.

_It's essential to be cautious when interacting with smart contracts, especially when executing write functions, as blockchain transactions are irreversible. Always double-check the inputs and the contract's behavior to avoid unintended consequences.
Keep in mind that the specific steps and options available for interacting with a smart contract through a block explorer may vary based on the block explorer's design and the features supported by the underlying blockchain network._

### 🔧 Troubleshooting

Not applicable.

## Back Matter

### :clap: Acknowledgements

Thanks to all these amazing people and tools that served as a source of knowledge or were an integral part in the construction of this project.

- [Luiz Tools](https://www.luiztools.com.br/) - Web3 Online Courses
- [Remix - Ethereum IDE](https://remix.ethereum.org/) - Online Code Editor
- [OpenZepellin](https://www.openzeppelin.com/) - Web3 Solidity Libraries
- [Pinata](https://app.pinata.cloud/) - IPFS File Sharing
- [Fleek](https://fleek.co/) - IPFS Hosting

### 🔎 See Also

- [Basic Token ERC-20](https://github.com/mabesi/solidity-coin-erc20)
- [Basic Token BEP-20](https://github.com/mabesi/solidity-coin-bep20)
- [Basic NFT ERC-721](https://github.com/mabesi/solidity-nft-erc721)
- [Basic Azuki NFT ERC-721A](https://github.com/mabesi/azuki-nft)

### ✒️ Authors & Contributors

| [<img loading="lazy" src="https://github.com/mabesi/mabesi/blob/master/octocat-mabesi.png" width=115><br><sub>Plinio Mabesi</sub>](https://github.com/mabesi) |
| :---: |


### 👮🏼‍♂️ Legal Disclaimer

<p align="justify">This tool was created for educational purposes and has the sole purpose of serving as an example of the implementation of a Smart Contract following the proposed standards, in accordance with what is contained in the references.</p>
<p align="justify">The use of this tool, for any purpose, will occur at your own risk, being your sole responsibility for any legal implications arising from it.</p>
<p align="justify">It is also the end user's responsibility to know and obey all applicable local, state and federal laws. Developers take no responsibility and are not liable for any misuse or damage caused by this program.</p>

### 📜 License

This project is licensed under the [MIT License](LICENSE.md).
