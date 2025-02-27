import { reduce } from 'lodash'
import { ethereum } from './chains'
import { Chain } from './types'

export const allowedChains = [ethereum]

export const allowedChainsConfig = reduce(
  allowedChains,
  (acc, chain: Chain) => {
    acc[chain.id] = chain

    return acc
  },
  {} as { [key: number]: Chain }
)
