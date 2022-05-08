const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const Contract = require('web3-eth-contract')


async function HavenXMarketplace(senderadd, provider_,) {
    const contractAddress = ""
    const rpcURL = provider_
    const web3 = new Web3(rpcURL)

    Contract.setProvider('ws://localhost:8546')
    const contract = new Contract(ABI, contractAddress)


    this.deploy_collection = async () => {

    }

}

module.exports = { HavenXMarketplace }
