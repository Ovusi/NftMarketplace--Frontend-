const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")

function DeployCollection(nftmarketaddress, senderadd, provider_, name, symbol) {
  const rpcURL = provider_
  const web3 = new Web3(rpcURL)

  const deploy_contract = new web3.eth.Contract(JSON.parse(ABI))

  const payload = {
    data: BYTE_CODE,
    arguments: [nftmarketaddress, senderadd, name, symbol]
  }

  const parameter = {
    from: senderadd,
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
