import { Chain as IChain } from 'viem'

export type AvailableChainContracts = 'lzEndpoint'

export type Chain = IChain & {
  accounts: string[]
}

export type ChainContracts = Chain['contracts']
