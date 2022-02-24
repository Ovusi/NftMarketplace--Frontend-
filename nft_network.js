import { ThirdwebSDK } from "@3rdweb/sdk";
import { NFTModule, NFTMetadataOwner } from "@3rdweb/sdk";


function NftNetwork() {
    // You can switch out this provider with any wallet or provider setup you like.
    const provider = ethers.Wallet.createRandom(); // set provider
    const sdk = new ThirdwebSDK(provider); // initialize sdk
    const module = sdk.getNFTModule("0x6aF30684100864bD53a6ccCA87B3c09aA79BD6DA"); // initialize module
    const market_module = sdk.getMarketplaceModule("0xe15f489890B50320a8D22bb3b3f30967f4Eba900");

    const mint = function() {
        // funtion to mint new nft
        const toAddress = "{{wallet_address}}"

        // Custom metadata of the NFT, note that you can fully customize this metadata with other properties.
        const metadata = {
        name: "Cool NFT",
        description: "This is a cool NFT",
        image: fs.readFileSync("path/to/image.png"), // This can be an image url or file
        }

        await module.mintTo(toAddress, metadata);
    }

    const list = function() {
        // function to list new nft on marketplace
    }
}
