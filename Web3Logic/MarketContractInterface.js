const Web3 = require('web3');
const Contract = require('web3-eth-contract')

require("dotenv").config()

// When users connect thier wallets, the provider is parsed
// as an argument to the HavenXMarketplace class.
// This allows users to interact with the marketplace contract.

function HavenXMarketplace(provider) {
  Contract.setProvider(provider)
  const marketcontract = new Contract(JSON.parse(process.env.ABI), process.env.MARKET_PLACE_ADDRESS)

  this.listNft = async (nftCollectionContract, tokenid, amount) => {
    /*
    This function lists an nft directly on the marketplace.
    ...
    ...
    listNft(
        address collectionContract,
        uint256 tokenid_,
        address amount,
        uint256 price_) returns (uint256)
    */

    await marketcontract.methods.listNft(nftCollectionContract, tokenid, amount).send()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.buyListing = async (listingid, currencycontract, amount) => {
    /* 
    This function allows you to purchase a direct nft listing
    ...
    ...
    buyNft(uint256 listingId_, address currency uint256 amount) returns (bool)
    */

    await marketcontract.methods.buyNft(listingid, currencycontract, amount).send()
      .then((data) => { return data })
      .catch((err) => { return err })
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

    await marketcontract.methods.placeAuction().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.bidAuctionedNft = async () => {
    /**
     * Create bid on an auctioned item.
     * ...
     * ...
     * bid(uint256 aId, uint256 price_)
     */

    await marketcontract.methods.bid().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.cancelDirectListing = async () => {
    /**
     * Cancel a direct listing.
     * Only owner of the listing can call this function.
     * ...
     * ...
     * cancelListing(uint256 lId) returns (bool, string memory)
     */

    await marketcontract.methods.cancelListing().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.cancelAuctionedItem = async () => {
    /**
     * Cancel an auctioned listing.
     * Only owner of the listing can call this function.
     * ...
     * ...
     * cancelAuction(uint256 aId) returns (bool, string memory
     */
    await marketcontract.methods.cancelAuction().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.createNewUser = async () => {
    /**
     * This function creates a new user or returns an existing user
     * when a wallet is connected.
     * ...
     * ...
     * createUser(string memory useruri_) external returns (bool)
     */
    await marketcontract.methods.createUser().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.withdrawBid = async () => {
    /**
     * Withdraws a bid
     * ...
     * ...
     * withdrawUnderBid(uint256 aId)
     */
    await marketcontract.methods.withdrawUnderBid().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.claimHighestBid = async () => {
    /**
     * Claim highest bid after auction period has elapsed.
     * ...
     * ...
     * withdrawHighestBid(uint256 aId) returns (bool, string memory)
     */
    await marketcontract.methods.withdrawHighestBid().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.claimWonNft = async () => {
    /**
     * 
     */
    await marketcontract.methods.claimNft().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.getAllMarketAuctions = async () => {
    /**
     * 
     */
    await marketcontract.methods.getAllAuctions().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.getAllMarketListings = async () => {
    /**
     * getAllListings() external view returns (uint256[] memory)
     */
    await marketcontract.methods.getAllListings().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.getTokenUriById = async () => {
    /**
     * getTokenUri(uint256 lId) external view returns (string memory)
     */
    await marketcontract.methods.getTokenUri().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.getListingById_ = async () => {
    /**
     * getListingById(uint256 lId)
        external
        view
        returns (Listing memory)
     */
    await marketcontract.methods.getListingById().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

  this.isUserVerified = async () => {
    /**
     * Check if user is verified
     * 
     * isVerified(address userAdd) external view returns (bool)
     */
    await marketcontract.methods.isVerified().call()
      .then((data) => { return data })
      .catch((err) => { return err })
  }

}

module.exports = { HavenXMarketplace }
