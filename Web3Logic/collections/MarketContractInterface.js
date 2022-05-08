const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const Contract = require('web3-eth-contract')


async function HavenXMarketplace(senderadd, provider_,) {
    const contractAddress = ""
    const rpcURL = provider_
    const web3 = new Web3(rpcURL)

    Contract.setProvider('ws://localhost:8546')
    const contract = new Contract(ABI, contractAddress)


    this.listNft = async () => {

    }

    this.buyListing = async () => {

    }

    this.auctionNft = async () => {

    }

    this.bidAuctioneNft = async () => {

    }

    this.cancelListing = async () => {

    }

    this.cancelAuction = async () => {

    }

    this.createUser = async () => {

    }

    this.withdrawBid = async () => {

    }

    this.claimHighestBid = async () => {

    }

    this.claimWonNft = async () => {

    }

    this.getAllMarketAuctions = async () => {

    }

    this.getAllMarketListings = async () => {

    }

    this.getTokenUriById = async () => {

    }

    this.getListingById_ = async () => {

    }

    this.isUserVerified = async () => {

    }

}

module.exports = { HavenXMarketplace }
