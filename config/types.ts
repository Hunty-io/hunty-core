import { Chain as IChain } from 'viem'

export type AvailableChainContracts = 'lzEndpoint'

export type Chain = IChain & {
  abstractId: number
  network: string
  accounts: string[]
}

export type ChainContracts = Chain['contracts']
