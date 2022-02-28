const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/node_modules/@3rdweb/react/node_modules/@3rdweb/hooks")


export const Component = () => {
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
