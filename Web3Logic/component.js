const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("@3rdweb/hooks")
const { Web3 } = require('web3');
import detectEthereumProvider from '@metamask/detect-provider';

async function ConnectWallet() {
    // This is the CUSTOM function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data

    const web3 = await new Web3(window.ethereum || Web3.givenProvider)
        .then((data) => {
            const cId = await web3.eth.getChainId()
            if (cId == 147) {
                const accounts = await web3.eth.getAccounts()
                const account = accounts[0]
                const provider = await web3.eth.currentProvider()
                const chainId = cId
                const balance = await web3.utils.fromWei(web3.eth.getBalance(account))

                const disconnectWallet = async () => {
                    if (accounts) {
                        // TODO: Add disconnetion logic
                        return "Wallet disconnected"
                    }
                }

                return {
                    account,
                    provider,
                    chainId,
                    balance,
                    disconnectWallet
                }
            } else {
                console.log("Network not supported!")
            }
        })
        .catch((err) => {
            if (typeof ethereum.isMetaMask() != true) {
                console.log('MetaMask is not installed!');
            } else {
                console.log(err)
            }
        })


}

async function ConnectMetamask() {
    // This is the CUSTOM function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data

    if (typeof ethereum.isMetaMask() != true) {
        console.log('MetaMask is not installed!');
    } else {
        accounts = await ethereum.request({ method: 'eth_requestAccounts' })
            .then((data) => {
                const chainId = await ethereum.request({ method: 'eth_chainId' })

                if (chainId == 147) {
                    const account = accounts[0]
                    const provider = await detectEthereumProvider()

                    const disconnectWallet = async () => {
                        if (account) {
                            // TODO: Add disconnetion logic
                            return "Wallet disconnected"
                        }
                    }

                    return {
                        account,
                        provider,
                        chainId,
                        disconnectWallet
                    }
                } else {
                    console.log("Wallet not supported!")
                }
            })
            .catch((err) => { })
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
