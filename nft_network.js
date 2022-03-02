
const { NFTModule, NFTMetadataOwner } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")
const { useWeb3, useSwitchNetwork, ThirdwebWeb3Provider } = require("C:/Users/Nobert Jakpor/Desktop/NftMarketplace (Frontend)/node_modules/@3rdweb/react/node_modules/@3rdweb/hooks")
const { useMemo, useState, useEffect } = require("react");
const { ethers } = require("ethers");
const { ThirdwebSDK } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")
const { readFileSync } = require('fs');
const { assert, error } = require("console");
const { Component } = require("../NftMarketplace (Frontend)/component")
const {  } = require("@3rdweb/hooks")


export function NftNetwork() {
    // initialize Component() to gain access to all its properties
    const comp = Component()

    const sdk = new ThirdwebSDK(comp.provider.getSigner(), 
    'https://speedy-nodes-nyc.moralis.io/82cc6856950dd22781f120a1/eth/rinkeby')

    this.nft_module = sdk.getNFTModule("0x6aF30684100864bD53a6ccCA87B3c09aA79BD6DA"); // initialize nft module
    this.market_module = sdk.getMarketplaceModule("0xe15f489890B50320a8D22bb3b3f30967f4Eba900");
    this.token_address = sdk.getTokenModule("0xBfF86A4188B84dd3Ed24D2aD9E5E6FdE7071e802")

    this.toAddress = comp.address

    this.mint_nft = async function (file_, categ) {
        // funtion to mint new nft
        // let file = readFileSync(file_);
        // Custom metadata of the NFT, note that you can fully customize this metadata with other properties.
        const metadata_ = {
            name: "",
            description: "",
            image: file_, // This can be an image url or file
            properties: {
                category: categ,
            },
        }
        
        const metadata = await this.nft_module.mintTo(this.toAddress, metadata_)
            .then((data) => console.log(data))
            .catch((err) => console.log(err));
        return metadata // to access ID's and store in leveldb.
    }

    this.list_nft = async function (id, assetcontractadd, starttimesecs, listingdurationsecs,
        quant, tokenprice) {
        // function to list new nft on marketplace
        // Data of the listing you want to create
        const listing = {
            // address of the contract the asset you want to list is on
            assetContractAddress: assetcontractadd, // str
            // token ID of the asset you want to list
            tokenId: id, // str
            // in how many seconds with the listing open up
            startTimeInSeconds: starttimesecs,
            // how long the listing will be open for
            listingDurationInSeconds: listingdurationsecs,
            // how many of the asset you want to list
            quantity: quant,
            // address of the currency contract that will be used to pay for the listing
            currencyContractAddress: token_address,
            // how much the asset will be sold for
            buyoutPricePerToken: tokenprice,
        }

        await this.market_module.createDirectListing(listing)
            .then((data) => console.log(data))
            .catch((err) => console.error(err));
    }

    this.buy_nft = async function (listid, quant) {
        // funtion to purchase nft
        // The listing ID of the asset you want to buy
        const listingId = listid;
        // Quantity of the asset you want to buy
        const quantityDesired = quant;

        await this.market_module.buyoutDirectListing({ listingId, quantityDesired })
            .catch((err) => console.error(err));
    }

    this.get_balance = async () => {
        // Get wallet ballance of a particular address
        await this.token_address.balanceOf(this.toAddress)
            .then((data) => console.log(data))
            .catch((err) => console.log(err))
    }

    this.get_all_listing = async () => {
        // get metadata of all listings in the marketplace
        await this.market_module.getAllListings()
            .then((data) => console.log(data))
            .catch((error) => console.error(error))
    }
}
