import { evmAccounts } from './accounts'
import { Chain } from './types'
import {
  arbitrum as arbitrumChain,
  arbitrumSepolia as arbitrumSepoliaChain,
  sepolia as sepoliaChain
} from 'viem/chains'
import { merge } from 'lodash'

export const arbitrum: Chain = merge(arbitrumChain, {
  accounts: evmAccounts
})

export const arbitrumSepolia: Chain = merge(arbitrumSepoliaChain, {
  accounts: evmAccounts
})

export const sepolia: Chain = merge(sepoliaChain, {
  accounts: evmAccounts
})
