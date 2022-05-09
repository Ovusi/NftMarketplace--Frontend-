const { ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")
const { Web3 } = require('web3');
const { ABI, BYTE_CODE, MARKET_ADDRESS, TOKEN_CONTRACT, TOKEN_ABI } = require("../collections/data")
const Contract = require('web3-eth-contract')
const { HavenXMarketplace } = require("./Web3Logic/MarketContractInterface")


const marketcontract = new Contract(ABI, MARKET_ADDRESS)
const hvxTokenContract = new Contract(TOKEN_ABI, TOKEN_CONTRACT)
const web3 = new Web3(Web3.givenProvider || "provider_")
const HVXMP = HavenXMarketplace(marketcontract, web3)

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