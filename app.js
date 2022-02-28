const { ThirdwebSDK } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")

export const MyApp = ({ children }) => {
    supportedChainIds = [4]
    connectors = {
    injected: {},
    walletconnect: {},
    walletlink: {
        appName: "thirdweb - demo",
        url: "https://thirdweb.com",
        darkMode: false,
        },
    }
    return (
        <ThirdwebWeb3Provider
            supportedChainIds={supportedChainIds}
            connectors={connectors}
        >
            {children}
        </ThirdwebWeb3Provider>
    )
}
