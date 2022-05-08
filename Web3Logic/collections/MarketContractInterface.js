const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const Contract = require('web3-eth-contract')
const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/node_modules/@3rdweb/react/node_modules/@3rdweb/hooks")

const { Signer, ethers } = require('ethers')
const { Component } = require("/Users/Nobert Jakpor//Desktop/NftMarketplace (Frontend)/component")


async function HavenXMarketplace(senderadd, provider_,) {
    const contractAddress = ""
    const provider = Component.provider
    const signer = provider.getSigner()
    const web3 = new Web3(provider)

    //const provider = Contract.setProvider('ws://localhost:8546')
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
