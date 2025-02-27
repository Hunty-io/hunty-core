import { evmAccounts } from './accounts'
import { Chain } from './types'
import { mainnet as mainnetChain } from 'viem/chains'
import { merge } from 'lodash'

export const ethereum: Chain = merge(mainnetChain, {
  accounts: evmAccounts
})
