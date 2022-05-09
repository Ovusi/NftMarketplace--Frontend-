const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("../collections/data")
const Contract = require('web3-eth-contract')
const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/node_modules/@3rdweb/react/node_modules/@3rdweb/hooks")

const { Signer, ethers } = require('ethers')
const { Component } = require("/Users/Nobert Jakpor//Desktop/NftMarketplace (Frontend)/component")


function HavenXMarketplace(senderadd, provider_,) {
    const marketcontract = new Contract(ABI, contractAddress)
    const web3 = new Web3(provider_)

    this.listNft = async () => {
        /*
        This function lists an nft directly on the marketplace.

        listNft(
        address token_,
        uint256 tokenid_,
        address currency,
        uint256 price_
    ) external nonReentrant returns (uint256)
        */

        return await marketcontract.methods.listNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.buyListing = async () => {
        /* 
        This function allows you to purchase a direct nft listing

        buyNft(uint256 listingId_, uint256 price_)
        external
        payable
        nonReentrant
        returns (bool)
        */

        return await marketcontract.methods.buyNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.auctionNft = async () => {
        /**
         * Create an nft auction.
         * 
         * placeAuction(
        address token_,
        uint256 tokenid_,
        uint256 aucEndTime,
        uint256 price_
    ) external nonReentrant returns (uint256)

         */
        return await marketcontract.methods.placeAuction().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.bidAuctionedNft = async () => {
        /**
         * Create bid on an auctioned item.
         * 
         * bid(uint256 aId, uint256 price_)
        external
        payable
        nonReentrant
        isClosed(aId)
         */
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
