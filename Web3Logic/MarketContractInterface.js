const { Web3 } = require('web3');
const { ABI, BYTE_CODE } = require("./collections/data")
const Contract = require('web3-eth-contract')
const { Signer, ethers } = require('ethers')


function HavenXMarketplace(hvxmarketaddress, provider_,) {
    const marketcontract = hvxmarketaddress //new Contract(ABI, contractAddress)
    const web3 = provider_ //new Web3(provider_)

    this.listNft = async () => {
        /*
        This function lists an nft directly on the marketplace.
        ...
        ...
        listNft(
            address token_,
            uint256 tokenid_,
            address currency,
            uint256 price_) returns (uint256)
        */

        return await marketcontract.methods.listNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.buyListing = async () => {
        /* 
        This function allows you to purchase a direct nft listing
        ...
        ...
        buyNft(uint256 listingId_, uint256 price_) returns (bool)
        */

        return await marketcontract.methods.buyNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.auctionNft = async () => {
        /**
         * Create an nft auction.  
         * ...
         * ...
         * placeAuction(
            address token_,
            uint256 tokenid_,
            uint256 aucEndTime,
            uint256 price_) returns (uint256)

         */

        return await marketcontract.methods.placeAuction().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.bidAuctionedNft = async () => {
        /**
         * Create bid on an auctioned item.
         * ...
         * ...
         * bid(uint256 aId, uint256 price_)
         */

        return await marketcontract.methods.bid().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.cancelDirectListing = async () => {
        /**
         * Cancel a direct listing.
         * Only owner of the listing can call this function.
         * ...
         * ...
         * cancelListing(uint256 lId) returns (bool, string memory)
         */

        return await marketcontract.methods.cancelListing().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.cancelAuctionedItem = async () => {
        /**
         * Cancel an auctioned listing.
         * Only owner of the listing can call this function.
         * ...
         * ...
         * cancelAuction(uint256 aId) returns (bool, string memory
         */
        return await marketcontract.methods.cancelAuction().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.createNewUser = async () => {
        /**
         * This function creates a new user or returns an existing user
         * when a wallet is connected.
         * ...
         * ...
         * createUser(string memory useruri_) external returns (bool)
         */
        return await marketcontract.methods.createUser().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.withdrawBid = async () => {
        /**
         * Withdraws a bid
         * ...
         * ...
         * withdrawUnderBid(uint256 aId)
         */
        return await marketcontract.methods.withdrawUnderBid().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.claimHighestBid = async () => {
        /**
         * Claim highest bid after auction period has elapsed.
         * ...
         * ...
         * withdrawHighestBid(uint256 aId) returns (bool, string memory)
         */
        return await marketcontract.methods.withdrawHighestBid().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.claimWonNft = async () => {
        /**
         * 
         */
        return await marketcontract.methods.claimNft().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getAllMarketAuctions = async () => {
        /**
         * 
         */
        return await marketcontract.methods.getAllAuctions().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getAllMarketListings = async () => {
        /**
         * getAllListings() external view returns (uint256[] memory)
         */
        return await marketcontract.methods.getAllListings().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getTokenUriById = async () => {
        /**
         * getTokenUri(uint256 lId) external view returns (string memory)
         */
        return await marketcontract.methods.getTokenUri().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.getListingById_ = async () => {
        /**
         * getListingById(uint256 lId)
            external
            view
            returns (Listing memory)
         */
        return await marketcontract.methods.getListingById().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

    this.isUserVerified = async () => {
        /**
         * Check if user is verified
         * 
         * isVerified(address userAdd) external view returns (bool)
         */
        return await marketcontract.methods.isVerified().call()
        .then((data) => console.log(data))
        .catch((err) => console.log(err))
    }

}

module.exports = { HavenXMarketplace }
