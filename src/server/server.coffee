restify = require "restify"
db = require "#{__dirname}/db"
uuidV4 = require "uuid/v4"

utils = require "./utils"

server = restify.createServer()

# initial connection
# sends a secret back which must be included in all future queries
server.get "/handshake/:name", (req, res, next) ->
  name = req.params.name
  uuid = uuidV4()
  secret = utils.random_id(21)

  client = new db.client {
    uuid: uuid
    name: name
    secret: secret
  }

  res.send {
    uuid: uuid
    name: name
    secret: secret
    success: true
  }

server.get "/:event/:uuid/:secret", (req, res, next) ->
  secret = req.params.secret
  uuid = req.params.uuid
  time = new Date().getTime

  # TODO: Client timeout
  switch req.params.event
    when "keep-alive" then
    when "arm" then
    when "trigger" then
    when "disarm" then
    when "disassoc" then
    else



server.listen 63833
