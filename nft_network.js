
const { NFTModule, NFTMetadataOwner } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")
//const { useWeb3, useSwitchNetwork } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/hooks")
const { useMemo, useState } = require("react");
//const { useModule } = require("./test")
const { Signer } = require("ethers");
const { ThirdwebSDK } = require("C:/Users/Nobert Jakpor/node_modules/@3rdweb/sdk")
const { readFileSync } = require('fs');
const { assert } = require("console");

/*const Component = () => {
    // This is the function that enables the connect wallet button in the dapp
    // You can do whatever you want with this returned data
    const { address, chainId, provider, connectWallet, disconnectWallet } = useWeb3(); // set provider
    const { switchNetwork } = useSwitchNetwork();
    return {
        address,
        chainId,
        provider,
        connectWallet,
        disconnectWallet,
        switchNetwork
    }
}*/

function NftNetwork(address_, chainId_, provider_, connectWallet_, disconnectWallet_) {
    const pr = 'https://speedy-nodes-nyc.moralis.io/82cc6856950dd22781f120a1/eth/rinkeby'
    // You can switch out this provider with any wallet or provider setup you like.
    this.sdk = new ThirdwebSDK(pr); // initialize sdk
    this.nft_module = this.sdk.getNFTModule("0x6aF30684100864bD53a6ccCA87B3c09aA79BD6DA"); // initialize module
    this.market_module = this.sdk.getMarketplaceModule("0xe15f489890B50320a8D22bb3b3f30967f4Eba900");
    this.token_address = this.sdk.getTokenModule("0xBfF86A4188B84dd3Ed24D2aD9E5E6FdE7071e802")
    this.toAddress = "0xeA84aC0D1712c505c970DB345C96706994f64Ab3"

    this.mint_nft = async function() {
        // funtion to mint new nft
        //let fs = require("C:\Users\Nobert Jakpor\Desktop\NftMarketplace (Frontend)\scadasys.png");
        
        let file = readFileSync("scadasys.png");

        // Custom metadata of the NFT, note that you can fully customize this metadata with other properties.
        const metadata_ = {
            name: "Cool NFT",
            description: "This is a cool NFT",
            image: file, // This can be an image url or file
            properties: {},
        }
        
        const metadata = await this.nft_module.mintTo(this.toAddress, metadata_)
        .then((data) => console.log(data))
        .catch((err) => console.log(err));
        return metadata // to access ID's and store in leveldb.
    }

    this.list_nft = async function(id, assetcontractadd, starttimesecs, listingdurationsecs,
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
        .catch((err) => console.log(err));
    }

    this.buy_nft = async function(listid, quant) {
        // funtion to purchase nft
        // The listing ID of the asset you want to buy
        const listingId = listid;
        // Quantity of the asset you want to buy
        const quantityDesired = quant;

        await this.market_module.buyoutDirectListing({ listingId, quantityDesired })
        .catch((err) => console.log(err));
    }
}

f = new NftNetwork
f.mint_nft()