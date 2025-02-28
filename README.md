# hunty-core

Hunty.io core contracts

## Getting Started

```shell
pnpm compile
pnpm typechain
pnpm node
```

## Step 1 - deploying contracts

Deploy Lending Aggregator:

| Argument             | Description                      | Default |
| -------------------- | -------------------------------- | ------- |
| `--treasury-address` | Treasury address to receive fees | Address |
| `--account-index`    | Account index to deploy from     | `0`     |

```bash
pnpm hardhat deploy-lending-aggregator --network 42161 --treasury-address 0x6815547453B8731A39eB420C11E45D6c685a677C
```

## Verifing contracts

Run this command to verify contracts on selected network

```bash
pnpm verify --network [networkid] --contract contracts/[ContractName].sol:[Contract] [contractAddress] [arguments]
```
