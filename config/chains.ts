import { evmAccounts } from './accounts'
import { Chain } from './types'

import { mainnet as mainnetChain } from 'viem/chains'

import { merge } from 'lodash'
import { Address } from 'viem'

/**
 *
 * Mainnets
 *
 */

export const ethereum: Chain = merge(mainnetChain, {
  abstractId: 101,
  network: 'homestead',
  name: 'Ethereum',
  accounts: evmAccounts,
  contracts: merge(mainnetChain.contracts, {
    lzEndpoint: {
      address: '0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675' as Address
    }
  }),
  minGasToTransferAndStoreRemote: 1_000_000n,
  minGasToTransferAndStoreLocal: 100_000n
})
