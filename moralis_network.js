import Moralis from "moralis/types";
import Web3 from "web3";


function MoralisNetwork() {
        /* Moralis init code */
    const serverUrl = "https://c8ghhjpwuhc0.usemoralis.com:2053/server";
    const appId = "Y4QYLPMmIPY7LCPEJ9mvdU5sYf0oLcX3xvzmDekP1";
    const sdk = Moralis
    sdk.start({ serverUrl, appId });
    const web3 = new Web3(window.ethereum)
    
    /* TODO: Add Moralis Authentication code */

    const auth = async function() {
        const user_auth = await sdk.authenticate().then(function (user) {
            user.set("name", document.getElementById('username').value);
            user.save();
            return user_auth.get("ethAddress")
        })
    }
}