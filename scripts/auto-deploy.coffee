# Description:
#   Webhook to git pull, npm update, and reboot the Hubot
#
# Dependencies:
#   bluebird: "^2.9.34"
#
# Configuration:
#   AUTO_DEPLOY_DEBUG - verbose logging
#
# Commands:
#   None
#
# Webhooks:
#   POST /auto-deploy - Initiate auto deploy sequence
#
# Author:
#   Devin Weaver @sukima <suki@tritarget.org>
#
Promise = require("bluebird")
child = Promise.promisifyAll(require "child_process")

module.exports = (robot) ->

  execCmd = (command) -> ->
    child.execAsync command

  logInfo = (message) -> (output) ->
    robot.logger.info(message)
    if output? && process.env.AUTO_DEPLOY_DEBUG
      robot.logger.info(output)

  logError = (output) ->
    robot.logger.error(output)

  restart = ->
    process.exit 0

  deploy = (req) ->
    Promise.resolve()
      .then(logInfo "Updating source files")
      .then(execCmd "git pull")
      .then(logInfo "Updating Node modules")
      .then(execCmd "npm update")
      .then(logInfo "Shutting down")
      .then(restart)
      .catch(logError)

  isDeployable = (req) ->
    req.header("X-GitHub-Event") == "pull_request" &&
    req.body.action == "closed" &&
    req.body.pull_request.merged

  robot.router.post "/auto-deploy", (req, res) ->
    res.end("Ok")
    deploy() if isDeployable(req)
