const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("@3rdweb/hooks")
const { Web3 } = require('web3');

function ConnectWallet() {
    // This is the CUSTOM function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data
    try {
        const web3 = new Web3(Web3.givenProvider || "provider_")
        const account = web3.eth.getAccounts()[0]
        const provider = web3.eth.currentProvider()
        const chainId = web3.eth.getChainId()
        const balance = web3.eth.getBalance()
        const accounts = web3.eth.requestAccounts()
        
        return {
            account,
            provider,
            chainId,
            balance,
            accounts,
        }
    } catch {}
    

}



function Component() {
    // This is the function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data
    const { address, chainId, provider, connectWallet, disconnectWallet } = useWeb3(); // set provider
    const { switchNetwork } = useSwitchNetwork();
    return {
        address,
        chainId,
        provider,
        connectWallet,
        disconnectWallet,
        switchNetwork
    }
}

module.exports = { Component, ConnectWallet }
