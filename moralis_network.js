import Moralis from "moralis/types";


function MoralisNetwork() {
        /* Moralis init code */
    const serverUrl = "https://c8ghhjpwuhc0.usemoralis.com:2053/server";
    const appId = "Y4QYLPMmIPY7LCPEJ9mvdU5sYf0oLcX3xvzmDekP1";
    const sdk = Moralis
    sdk.start({ serverUrl, appId });

    /* TODO: Add Moralis Authentication code */

    const auth = async function() {
        const user_auth = await sdk.authenticate()
    }

}