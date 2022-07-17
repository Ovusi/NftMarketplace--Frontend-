const pinataSDK = require("@pinata/sdk")


function PinataConnect(apiKey, secreteApiKey) {
  const pinata = pinataSDK(apiKey, secreteApiKey)

  const isAuthenticated = async () => {
    await pinata.testAuthentication().then((result) => {
      //handle successful authentication here
      return result.authenticated
    }).catch((err) => {
      //handle error here
      return err
    })
  }

  this.pinFile = async (imageURI, metadata) => {
    if (isAuthenticated() == true)
      await pinata.pinFileToIPFS(imageURI, metadata).then((result) => {
        return result
      }).catch((err) => {
        return err
      })
    else return "An error ocuured!"
  }
}


module.exports = PinataConnect