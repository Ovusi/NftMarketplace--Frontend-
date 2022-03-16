const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const { Component } = require("/../Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/component")

async function DeployCollection() {
    const comp = Component()
    const rpcURL = "http://127.0.0.1:7545"
    const web3 = new Web3(rpcURL)

    const deploy_contract = new web3.eth.Contract(JSON.parse(ABI))

    const payload = {
        data: BYTE_CODE
    }

    const parameter = {
        from: comp.address
    }

    await deploy_contract.deploy(payload).send(parameter, (err, transactionHash) => {
        console.log('Transaction Hash :', transactionHash);
    }).on('confirmation', () => { }).then((newContractInstance) => {
        console.log('Deployed Contract Address : ', newContractInstance.options.address);
    })

}
