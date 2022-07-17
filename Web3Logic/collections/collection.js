const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")

require("dotenv").config()

function DeployCollection(account, provider_, name, symbol) {
  const web3 = new Web3(provider_)

  const deploy_contract = new web3.eth.Contract(JSON.parse(process.env.ABI))

  const payload = {
    data: process.env.BYTE_CODE,
    arguments: [name, symbol]
  }

  const parameter = {
    from: account,
    gas: 1500000,
    gasPrice: '30000000000000'
  }

  this.deploy_collection = async () => {
    await deploy_contract.deploy(payload).send(parameter, (err, transactionHash) => {
      return {'Transaction Hash': transactionHash};
    }).on('confirmation', () => { }).then((newContractInstance) => {
      return {'Deployed Contract Address': newContractInstance.options.address}
    })

    return newContractInstance.options.address
  }

}

module.exports = { DeployCollection }
