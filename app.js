const { ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")

const App = ({ children }) => {
    const supportedChainIds = [4]
    const connectors = {
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

export default App