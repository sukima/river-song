# Description:
#   Hubot make me a sandwich
#
# Dependencies:
#   google-images
#
# Configuration:
#   None
#
# Commands:
#   hubot make me a sandwich - Make me a sandwich!
#
# Author:
#   @sukima (forked from spoike)

Promise = require "bluebird"
google = Promise.promisifyAll(require "google-images")

getSandwiches = (term, authorized) ->
  if authorized
    google.searchAsync(term)
      .map (result) -> result.url
  else
    Promise.reject()

module.exports = (robot) ->

  robot.respond /(sudo )?make(?: me)?(?: a)? (.*)/i, (msg) ->
    sudo = msg.match[1] is "sudo "
    term = if /sa(nd?w|mm)ict?s?h/.test(msg.match[2])
      "sandwich"
    else
      msg.match[2]
    getSandwiches(term, sudo)
      .then (sandwiches) ->
        msg.reply "Okay #{msg.random sandwiches}"
      .catch ->
        msg.reply "What? Make it yourself."
