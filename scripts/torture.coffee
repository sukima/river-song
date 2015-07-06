# Description:
#   Torture a victum with verbal and emotive torments
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot torture <user name>
#
# Author:
#   sukima

TORTURES = [
  # Emotes start with /me
  # {name} is replaced with the username preceded with an @ symbol (i.e. @sukima)
  "/me takes {name} over her knee and spanks {name}'s bottom."
]

module.exports = (robot) ->
  robot.respond /torture (.+)/i, (msg) ->
    name = msg.match[1].trim().replace(/^@?/, "@")
    response = msg.random(TORTURES).replace(/{name}/g, name)
    msg.send(response)
