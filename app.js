const { ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")
const { Web3 } = require('web3');
const { ABI, BYTE_CODE, MARKET_ADDRESS } = require("../collections/data")
const Contract = require('web3-eth-contract')


const marketcontract = new Contract(ABI, MARKET_ADDRESS)
const web3 = new Web3(provider_)

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