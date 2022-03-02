const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("@3rdweb/hooks")


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

module.exports = { Component }
