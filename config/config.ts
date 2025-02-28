import { reduce } from 'lodash'
import { arbitrum, arbitrumSepolia, sepolia } from './chains'
import { Chain } from './types'

export const allowedChains = [arbitrum, arbitrumSepolia, sepolia]

export const allowedChainsConfig = reduce(
  allowedChains,
  (acc, chain: Chain) => {
    acc[chain.id] = chain

    return acc
  },
  {} as { [key: number]: Chain }
)
