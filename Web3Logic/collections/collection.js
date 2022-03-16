const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const { Component } = require("/../Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/component")

async function DeployCollection(name, symbol) {
    const comp = Component()
    const rpcURL = comp.provider
    const web3 = new Web3(rpcURL)

    const deploy_contract = new web3.eth.Contract(JSON.parse(ABI))

    const payload = {
        data: BYTE_CODE,
        arguments: web3.eth.abi.encodeParameters(["address", "address", "string", "string"], [nftmarketaddress, senderadd, name, symbol])
    }

    const parameter = {
        from: comp.address
    }

    this.deploy_collection = async () => {
        await deploy_contract.deploy(payload).send(parameter, (err, transactionHash) => {
            console.log('Transaction Hash :', transactionHash);
        }).on('confirmation', () => { }).then((newContractInstance) => {
            console.log('Deployed Contract Address : ', newContractInstance.options.address);
        })

        return newContractInstance.options.address
    }

}
