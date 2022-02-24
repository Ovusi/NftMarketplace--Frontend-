import { ThirdwebSDK } from "@3rdweb/sdk";
import { NFTModule, NFTMetadataOwner } from "@3rdweb/sdk";


function NftNetwork() {
    // You can switch out this provider with any wallet or provider setup you like.
    const provider = ethers.Wallet.createRandom(); // set provider
    const sdk = new ThirdwebSDK(provider); // initialize sdk
    const module = sdk.getNFTModule(""); // initialize module

    const mint = function() {
        // funtion to mint new nft
    }

    const list = function() {
        // function to list new nft on marketplace
    }
}
