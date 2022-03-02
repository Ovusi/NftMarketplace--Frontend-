const level = require("level")
const levelup = require("../NftMarketplace (Frontend)/node_modules/levelup")
const leveldown = require("leveldown")

/* This module contains database functions for users and listing ids.
   It uses the LevelDb database. */


function Users() {
    const db = level("userDb") // Create database store

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
            .then((data) => console.log(JSON.parse(data)))
            .catch((err) => console.log("NO"))
    }

    this.getAllKeys = async () => {
        const keys = []
        for await (const [key, value] of db.iterator()) {
            keys.push(key)
        }
        console.log(keys)
    }
}


function ListingIds() {
    const db = level("lisingIdDb") // Create database store

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
            .then((data) => console.log(JSON.parse(data)))
            .catch((err) => console.log("NO"))
    }

    this.getAllKeys = async () => {
        const keys = []
        for await (const [key, value] of db.iterator()) {
            keys.push(key)
        }
        console.log(keys)
    }
}

module.exports = { Users, ListingIds }