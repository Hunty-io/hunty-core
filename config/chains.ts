import { evmAccounts } from './accounts'
import { Chain } from './types'
import {
  arbitrum as arbitrumChain,
  arbitrumSepolia as arbitrumSepoliaChain
} from 'viem/chains'
import { merge } from 'lodash'

export const arbitrum: Chain = merge(arbitrumChain, {
  accounts: evmAccounts
})

export const arbitrumSepolia: Chain = merge(arbitrumSepoliaChain, {
  accounts: evmAccounts
})
