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

getSandwiches = (sudo) ->
  if sudo
    google.searchAsync("sandwich")
      .map (result) -> result.url
  else
    Promise.reject()

module.exports = (robot) ->

  robot.respond /(sudo )?make( me)?( a)? sandwict?s?h/i, (msg) ->
    getSandwiches(msg.match[1] is "sudo ")
      .then (sandwiches) ->
        msg.reply "Okay #{msg.random sandwiches}"
      .catch ->
        msg.reply "What? Make it yourself."
