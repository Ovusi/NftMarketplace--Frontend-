const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")

require("dotenv").config()

class DeployCollection {
  constructor(account, provider_, name, symbol) {
    try {
      const web3 = new Web3(provider_);
      this.deploy_contract = new web3.eth.Contract(JSON.parse(process.env.ABI));
  
      this.payload = {
        data: process.env.BYTE_CODE,
        arguments: [name, symbol]
      };
  
      this.parameter = {
        from: account,
        gas: 1500000,
        gasPrice: '30000000000000'
      };

      console.log('Connected to the Blockchain successfully.')
      return 'Connected to the Blockchain successfully.'
      
    } catch (error) {
      console.log(error)
      return 'An error occured.'
    }
  }

  deploy_collection = async () => {
    await this.deploy_contract.deploy(this.payload).send(this.parameter, (err, transactionHash) => {
      return { 'Transaction Hash': transactionHash };
    }).on('confirmation', () => { }).then((newContractInstance) => {
      return { 'Deployed Contract Address': newContractInstance.options.address };
    });

    return newContractInstance.options.address;
  };
}

module.exports = { DeployCollection }
