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
#   hubot prowl help - explain to the user what this script does
#   hubot prowl me with YOUR_PROWL_API_KEY - register user to recive messages
#   hubot prowl off - unregister user
#   hubot prowl list - list all registered users
#   hubot tell user message - send a message to registered user
#   hubot tell everyone message - send a message to all regigistered users
#
# Notes:
#   To use this service you will need to register a device and account at
#   http://www.prowlapp.com/
#
# Author:
#   sukima
#   refactored from marten's notify.coffee in hubot-scripts
#
Prowl = require "prowler"
PROWL_URL = "http://www.prowlapp.com/"

class Notifier
  constructor: (@robot) ->
    @robot.brain.data.notifiers ?= {}
  send: (opts) ->
    notifies = []
    username = opts.username.toLowerCase()
    message = if not opts.message? or opts.message is ""
      "#{opts.sender} wanted to get in touch with you"
    else
      opts.message
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
        event: "Message"
        description: message
    notifies.length
  add: (user, apikey) ->
    @robot.brain.data.notifiers[user.toLowerCase()] = apikey.toLowerCase()
  remove: (user) ->
    user = user.toLowerCase()
    if @robot.brain.data.notifiers[user]?
      delete @robot.brain.data.notifiers[user]
      true
    else
      false
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
    names.join(delimiter)

module.exports = (robot) ->
  notifier = new Notifier(robot)

  robot.respond /prowl( help)?$/i, (msg) ->
    name = robot.name
    msg.send """
      I can send messages to people, just let me now with "#{name} tell username something".
      I use a service called Prowl which you can sign up for at #{PROWL_URL}.
      To start using this just let me know your Prowl API key: "#{name} prowl on XXXXXXXX".
      And if you want me to stop just tell me: "#{name} prowl off".
      To see who has given me their API key: "#{name} prowl list".
      """

  robot.respond /(?:tell|message|notify) (\w+)\s*(.*)$/i, (msg) ->
    username = msg.match[1].toLowerCase()
    message = msg.match[2]
    username = "everyone" if username is "all" # Normalize for output below
    result = notifier.send
      username: username
      sender: msg.message.user.name
      message: message
    if result > 0
      msg.send "I'll let #{username} know. :iphone:"
    else if result < 0
      msg.send "Sorry, no one else has registered a prowl api key yet."
    else
      msg.send "Sorry, #{username} has not registered their prowl api key yet."
 
  robot.respond /prowl off$/i, (msg) ->
    if notifier.remove(msg.message.user.name)
      msg.send "Ok, your prowl api key has been forgotten."
    else
      msg.send "Looks like your not registered anyway. No worries."

  robot.respond /prowl (me|on)$/i, (msg) ->
    msg.send "I would love to, but I'll need your Prowl API key. Get it at #{PROWL_URL}"

  robot.respond /prowl (?:me with|on) (\w+)$/i, (msg) ->
    notifier.add msg.message.user.name, msg.match[1]
    msg.send "Ok, your prowl api key has been memorized."

  robot.respond /prowl list$/i, (msg) ->
    if response = notifier.getList()
      msg.send "I know how to notify #{response} via prowl."
      if apikey = notifier.getApiKeyFor(msg.message.user.name)
        msg.send "Your API key is '#{apikey}'."
    else
      msg.send "No one has told me their prowl api key yet."
