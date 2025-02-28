import dotenv from 'dotenv'

dotenv.config()

import { HardhatUserConfig } from 'hardhat/config'

import '@nomicfoundation/hardhat-verify'
import '@nomicfoundation/hardhat-toolbox'

import '@nomiclabs/hardhat-solhint'

import 'hardhat-gas-reporter'
import 'tsconfig-paths/register'
import './tasks'

import { allowedChainsConfig } from '@/config/config'
import { reduce } from 'lodash'
import { Chain } from './config/types'
import { NetworksUserConfig } from 'hardhat/types'

const config: HardhatUserConfig = {
  defaultNetwork: 'hardhat',
  networks:
    process.env.NODE_ENV !== 'development'
      ? reduce(
          Object.values(allowedChainsConfig),
          (acc, chain: Chain) => {
            acc[chain.id] = {
              url: chain.rpcUrls.default.http[0],
              accounts: chain.accounts
              // gasPrice: chain.gasPrice,
            }

            return acc
          },

          {} as NetworksUserConfig
        )
      : {
          localhost: {
            url: 'http://127.0.0.1:8545'
          },
          hardhat: {}
        },
  solidity: {
    version: '0.8.21',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v6'
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 1,
    enabled: process.env.RUN_GAS_REPORTER === 'true'
  },
  etherscan: {
    apiKey: {
      arbitrum: process.env.ARBITRUM_API_KEY!,
      arbitrumSepolia: process.env.ARBITRUM_API_KEY!
    }
  }
}

export default config
