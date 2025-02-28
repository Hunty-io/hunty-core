import { evmAccounts } from './accounts'
import { Chain } from './types'
import { arbitrum as arbitrumChain } from 'viem/chains'
import { merge } from 'lodash'

export const arbitrum: Chain = merge(arbitrumChain, {
  accounts: evmAccounts
})
