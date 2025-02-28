import { task, types } from 'hardhat/config'
import { Spinner } from '../scripts/spinner'
import cliSpinner from 'cli-spinners'
import { allowedChainsConfig } from '@/config/config'

const spinner: Spinner = new Spinner(cliSpinner.triangle)

export type DeployTemplateTask = {
  accountIndex?: number
  treasuryAddress?: string
}

task('deploy-lending-aggregator', 'deploy lending aggregator contract')
  .addOptionalParam(
    'treasuryAddress',
    'Treasury Address',
    process.env.TREASURY_PUBLIC_ADDRESS,
    types.string
  )
  .addOptionalParam(
    'accountIndex',
    'Account index to use for deployment',
    0,
    types.int
  )
  .setAction(
    async ({ accountIndex, treasuryAddress }: DeployTemplateTask, hre) => {
      spinner.start()

      try {
        const chainConfig = allowedChainsConfig[+hre.network.name]
        if (!chainConfig) {
          spinner.stop()
          throw new Error('Chain config not found')
        }

        const provider = new hre.ethers.JsonRpcProvider(
          chainConfig.rpcUrls.default.http[0],
          chainConfig.id
        )

        const deployer = new hre.ethers.Wallet(
          chainConfig.accounts[accountIndex || 0],
          provider
        )

        /**
         * deploying contract
         */

        console.log(
          `ℹ️  Deploying Lending Aggregator contract to chain ${chainConfig.name}`
        )

        const lendingAggregator = await hre.ethers.deployContract(
          'LendingAggregator',
          [treasuryAddress],
          deployer
        )

        const tx = await lendingAggregator.waitForDeployment()

        const receipt = await tx.deploymentTransaction()?.wait()
        const gasUsed = receipt?.gasUsed || 0n
        spinner.stop()

        console.log('ℹ️ Gas used: ', gasUsed)

        /**
         * getting address
         */

        spinner.start()
        console.log(`ℹ️  Checking deployed contract`)

        const lendingAggregatorAddress = await lendingAggregator.getAddress()

        spinner.stop()
        console.log(
          `✅ LendingAggregator deployed at ${lendingAggregatorAddress}`
        )
      } catch (error) {
        spinner.stop()
        console.log(`❌ `)
        console.log(error)
      }
    }
  )
