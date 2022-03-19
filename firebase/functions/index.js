const functions = require("firebase-functions")
const axios = require("axios")

const low_memory = {
  memory: "128MB"
}

exports.fetchServerTimestamp = functions
  .runWith(low_memory)
  .https.onCall(() => {
    const date = new Date()
    let timestanp = date.valueOf()
    return timestanp
  })

exports.fetchKey = functions.runWith(low_memory).https.onCall(() => {
  /* const key = "VZBJYWD-J8P4V67-J5WTNZ9-J58WGZF"
  const url = "https://shot.screenshotapi.net/screenshot?token=" + key
  const full_url = url + parameters
  const response = axios.get(full_url) */
  const keys = [
    "8b30f47579f84df0a269c6f544f25040",
    "d01b4f0580dc4a3fa561cd0dabf21e84"
  ]
  const randomIndex = randomInt(0, keys.length-1)
  return keys[randomIndex]
})

function randomInt(max, min) {
  return Math.round(Math.random() * (max - min)) + min
}
