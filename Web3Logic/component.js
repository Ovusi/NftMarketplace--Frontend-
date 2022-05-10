const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("@3rdweb/hooks")
const { Web3 } = require('web3');
import detectEthereumProvider from '@metamask/detect-provider';

async function ConnectWallet() {
    // This is the CUSTOM function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data
    try {
        const web3 = new Web3(Web3.givenProvider || "provider_")
        const account = await web3.eth.getAccounts()[0]
        const provider = await web3.eth.currentProvider()
        const chainId = await web3.eth.getChainId()
        const balance = await web3.eth.getBalance(account)
        const accounts = await web3.eth.requestAccounts()

        return {
            account,
            provider,
            chainId,
            balance,
            accounts,
        }
    } catch { }


}

async function ConnectMetamask() {
    // This is the CUSTOM function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data

    if (typeof ethereum.isMetaMask() != true) {
        console.log('MetaMask is not installed!');
    } else {
        accounts = await ethereum.request({ method: 'eth_requestAccounts' })
            .then((data) => {
                if (data) {
                    const account = accounts[0]
                    const provider = await detectEthereumProvider()
                    const chainIds = await ethereum.request({ method: 'eth_chainId' })
                    const chainId = chainIds[0]

                    return {
                        account,
                        provider,
                        chainId
                    }
                }
            })
            .catch((err) => {})
    }
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
