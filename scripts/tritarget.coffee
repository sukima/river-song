fs         = require "fs"
Connection = require "ssh2"

sshCommand = "/home/suki/dev-tritarget-org/deploy.sh --notify --rsync"

sendError = (msg, error) ->
  msg.send "Ugh... Something didn't agree with me. :mask:"
  msg.send error.message || error

deployTritarget = (msg, privateKey, branch="") ->
  conn = new Connection()
  conn.on "ready", ->
    conn.exec sshCommand, (err, stream) ->
      if err
        sendError(msg, err)
      else
        stream.on "close", -> conn.end()

  conn.connect {
    host:       "cerberus.tritarget.org"
    port:       2222
    username:   "suki"
    privateKey
  }

module.exports = (robot) ->
  room = null

  robot.brain.on 'loaded', =>
    robot.brain.data.tritarget_key ||= ""

  robot.respond /deploy(?:\s+(.+))?/i, (msg) ->
    room = msg.message.room
    try
      deployTritarget(msg, robot.brain.data.tritarget_key, msg.match[1])
      msg.send "Workin' on it :bowtie:"
    catch err
      sendError(msg, err)

  robot.router.post "/deploy/dev-tritarget-org", (req, res) ->
    fs.readFile req.files.key.path, (err, data) ->
      return res.end err if err
      robot.brain.data.tritarget_key = data.toString("utf8")
      res.end "Saved"

  robot.router.get "/deploy/dev-tritarget-org", (req, res) ->
    return res.end("Ok") unless room?

    message = if req.query.success == "true"
      "Deployment of http://tritarget.org/ complete. :shipit:"
    else
      "Oh no, something went wrong with the deployment. :cold_sweat:"

    robot.messageRoom room, message
    res.end "Ok"
