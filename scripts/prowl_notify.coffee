# Description:
#   Allows people to send a message to registered prowl accounts.
#
# Dependencies:
#   "prowler": "0.0.3"
#
# Configuration:
#   None
#
# Commands:
#   hubot prowl me with YOUR_PROWL_API_KEY - register to recive messages
#   hubot prowl off - unregister
#   hubot prowl list - list all registered users
#   @user message - send a message to registered user
#   @all message - send a message to all regigistered users
#
# Author:
#   sukima
#   refactored from marten's notify.coffee in hubot-scripts
#
Prowl = require "prowler"

class Notifier
  constructor: (@robot) ->
    @robot.brain.data.notifiers ?= {}
  send: (opts) ->
    notifies = []
    username = opts.username.toLowerCase()
    if username is "all" or username is "everyone"
      for user, apikey of @robot.brain.data.notifiers
        notifies.push apikey unless user is opts.sender.toLowerCase()
      return -1 if notifies.length is 0
    else if apikey = @robot.brain.data.notifiers[username]
      notifies.push apikey
    for notifier in notifies
      notification = Prowl.connection(apikey)
      notification.send
        application: "#{@robot.name} notify"
        event: "Mention"
        description: opts.message
    notifies.length
  add: (user, apikey) ->
    @robot.brain.data.notifiers[user.toLowerCase()] = apikey.toLowerCase()
  remove: (user) ->
    delete @robot.brain.data.notifiers[user.toLowerCase()]
  getApiKeyFor: (user) ->
    @robot.brain.data.notifiers[user.toLowerCase()]
  getList: ->
    names = []
    delimiter = ""
    names.push name for name of @robot.brain.data.notifiers
    if names.length is 0
      return false
    if names.length is 2
      i = names.length - 1
      names[i] = "and #{names[i]}"
    if names.length > 2
      delimiter = ", "
    return names.join(delimiter)

module.exports = (robot) ->
  notifier = new Notifier(robot)

  robot.hear /@(\w+)/i, (msg) ->
    username = msg.match[1].toLowerCase()
    username = "everyone" if username is "all" # Normalize for output below
    result = notifier.send
      username: username
      sender: msg.message.user.name
      message: msg.message.text
    if result > 0
      msg.send "I'll let #{username} know. :iphone:"
    else if result < 0
      msg.send "Sorry, no one else has registered a prowl api key yet."
    else
      msg.send "Sorry, #{username} has not registered their prowl api key yet."
 
  robot.respond /prowl off/i, (msg) ->
    notifier.remove(msg.message.user.name)
    msg.send "Ok, your prowl api key has been forgotten."

  robot.respond /prowl (?:me with|on) (\w+)/i, (msg) ->
    notifier.add msg.message.user.name, msg.match[1]
    msg.send "Ok, your prowl api key has been memorized."

  robot.respond /prowl list/i, (msg) ->
    if response = notifier.getList()
      msg.send "I know how to notify #{response} via prowl."
      if apikey = notifier.getApiKeyFor(msg.message.user.name)
        msg.send "Your API key is '#{apikey}'."
    else
      msg.send "No one has told me their prowl api key yet."
