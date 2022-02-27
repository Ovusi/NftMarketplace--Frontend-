import { ThirdwebSDK } from "@3rdweb/sdk";
import { NFTModule, NFTMetadataOwner } from "@3rdweb/sdk";
import { useWeb3 } from "@3rdweb/hooks"
import { useMemo } from "react"
import { useModule } from "./test";
import { Signer } from "ethers";



class NftNetwork {
    // You can switch out this provider with any wallet or provider setup you like.
    constructor() {
        this.name = ""
        /*const { address, chainId, provider, connectWallet, disconnectWallet } = useWeb3(); // set provider*/
    const sdk = new ThirdwebSDK(provider?.getSigner() instanceof Signer); // initialize sdk
    this.nft_module = sdk.getNFTModule("0x6aF30684100864bD53a6ccCA87B3c09aA79BD6DA"); // initialize module
    this.market_module = sdk.getMarketplaceModule("0xe15f489890B0a8D22bb3b3f30967f4Eba900");
    this.token_address = sdk.getTokenModule("0xBfF86A4188B84dd3Ed24D2aD9E5E6FdE7071e802")
    }
    
    
    mint_nft = function(address) {
        // funtion to mint new nft
        const toAddress = address

        // Custom metadata of the NFT, note that you can fully customize this metadata with other properties.
        const metadata = {
            name: "Cool NFT",
            description: "This is a cool NFT",
            image: fs.readFileSync("path/to/image.png"), // This can be an image url or file
        }
        
        const metadata = await this.nft_module.mintTo(toAddress, metadata);
        return metadata
    }

    list_nft = function(id, assetcontractadd, starttimesecs, listingdurationsecs,
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
        
        await this.market_module.createDirectListing(listing);
    }

    buy_nft = function(this,listid, quant) {
        // funtion to purchase nft
        // The listing ID of the asset you want to buy
        const listingId = listid;
        // Quantity of the asset you want to buy
        const quantityDesired = quant;
        await this.market_module.buyoutDirectListing({ listingId, quantityDesired });
    }
}

f = new NftNetwork