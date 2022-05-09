const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const Contract = require('web3-eth-contract')
const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/node_modules/@3rdweb/react/node_modules/@3rdweb/hooks")

const { Signer, ethers } = require('ethers')
const { Component } = require("/Users/Nobert Jakpor//Desktop/NftMarketplace (Frontend)/component")


async function HavenXMarketplace(senderadd, provider_,) {
    const marketcontract = new Contract(ABI, contractAddress)
    const web3 = new Web3(provider_)

    this.listNft = async () => {
        return await marketcontract.methods.listNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.buyListing = async () => {
        return await marketcontract.methods.buyNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.auctionNft = async () => {
        return await marketcontract.methods.placeAuction().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.bidAuctionedNft = async () => {
        return await marketcontract.methods.bid().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.cancelDirectListing = async () => {
        return await marketcontract.methods.cancelListing().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.cancelAuctionedItem = async () => {
        return await marketcontract.methods.cancelAuction().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.createNewUser = async () => {
        return await marketcontract.methods.createUser().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.withdrawBid = async () => {
        return await marketcontract.methods.withdrawUnderBid().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.claimHighestBid = async () => {
        return await marketcontract.methods.withdrawHighestBid().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.claimWonNft = async () => {
        return await marketcontract.methods.claimNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getAllMarketAuctions = async () => {
        return await marketcontract.methods.getAllAuctions().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getAllMarketListings = async () => {
        return await marketcontract.methods.getAllListings().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getTokenUriById = async () => {
        return await marketcontract.methods.getTokenUri().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getListingById_ = async () => {
        return await marketcontract.methods.getListingById().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.isUserVerified = async () => {
        return await marketcontract.methods.isVerified().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

}

module.exports = { HavenXMarketplace }
