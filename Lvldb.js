const level = require("level")
const levelup = require("../NftMarketplace (Frontend)/node_modules/levelup")
const leveldown = require("leveldown")

/*  */


function Users() {
    const db = level("mydb") // Create database store

    this.add = async (key, value) => {
        const keyString = JSON.stringify(key)
        const valueString = JSON.stringify(value)

        await db.put(keyString, valueString)
            .then((data) => console.log(data))
            .catch((err) => console.log(err))
    }

    this.retreive = async (key) => {
        const keyString = JSON.stringify(key)
        await db.get(keyString)
            .then((data) => {return console.log(JSON.parse(data))})
            .catch((err) => console.log("NO"))
    }
}
ddb = new Users()
ddb.add(22, {num: 44})
const tt = ddb.retreive(22)
console.log(tt)
const v = {num: 40904}
console.log(v.num)

