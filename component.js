const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("@3rdweb/hooks")
const { Web3 } = require('web3');

function ConnectWallet() {
    try {
        const web3 = new Web3(Web3.givenProvider || "provider_")
        return {
            account: web3.eth.getAccounts()[0],
            provider: web3.eth.currentProvider(),
            chainId: web3.eth.getChainId(),
            balance: web3.eth.getBalance(),
            accounts: web3.eth.requestAccounts()
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
