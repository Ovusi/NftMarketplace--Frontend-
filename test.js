// TEST SCRIPT


function Test(be) { // object
    const word = be
    this.f = function() {// method
        return word
    }
    this.g = function(word) {
        return word
    }
}
const w = new Test("me")
console.log(w.f())
console.log(w.g("dgdgd"))


const Component = (address, chainId, provider, connectWallet, disconnectWallet) => {
    // You can do whatever you want with this data
    //const { address, chainId, provider, connectWallet, disconnectWallet } = useWeb3(); // set provider.
        address,
        chainId,
        provider,
        connectWallet,
        disconnectWallet
    }
}
console.log(Component(1, 2, 3, 4, 5,))
const ad = Component(1, 255, 3, 4, 5)
console.log(ad.chainId)

// const prompt = require("prompt-sync")({ sigint: true })
// const pro = prompt("input: ");
// alert('enter text: '+ pro);
// Ajax for sending http requests






/*import { useWeb3, useSwitchNetwork } from "@3rdweb/hooks";
import { ThirdwebSDK } from "@3rdweb/sdk";
import { Signer } from "ethers";
import { useMemo,useState } from "react";

export const useModule = () => {
    const { address, chainId, provider, connectWallet, disconnectWallet } = useWeb3();
    const sdk = useMemo(() => {
        if (provider) {
        return new ThirdwebSDK(provider?.getSigner() instanceof Signer); // instanceof used in place of as or =
        }
        return undefined;
    }, [provider]);
    // instantiate the sdk
    const nftCollection = useMemo(() => {
        if (sdk) {
        return sdk.getNFTModule("0x6aF30684100864bD53a6ccCA87B3c09aA79BD6DA");
        }
        return undefined;
    }, [sdk]);
    return nftCollection
    /*const nftMarket = useMemo(() => {
        if (sdk) {
        return sdk.getMarketplaceModule("0xe15f489890B0a8D22bb3b3f30967f4Eba900");
        }
        return nftMarket;
    }, [sdk]);

    const token = useMemo(() => {
        if (sdk) {
        return f = sdk.getTokenModule("0xBfF86A4188B84dd3Ed24D2aD9E5E6FdE7071e802");
        }
        return token;
    }, [sdk]);*/
    

