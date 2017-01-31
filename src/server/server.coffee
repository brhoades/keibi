restify = require "restify"
db = require("./db").init()

utils = require "./utils"

server = restify.createServer()

# initial connection
# sends a secret back which must be included in all future queries
server.get "/handshake/:name", (req, res, next) ->
  name = req.params.name
  secret = utils.random_id(21)

  client = new db.client({
    name: name
    secret: secret
  }).save().then (client) ->
    utils.respond res, {
        client_id: client.id
        name: name
        secret: secret
    }

server.get "/event/:event/:id/:secret", (req, res, next) ->
  secret = req.params.secret
  id = req.params.id
  time = new Date().getTime

  # TODO: Client timeout
  switch req.params.event
    when "keep-alive" then
    when "arm" then
    when "trigger" then
    when "disarm" then
    when "disassoc" then
    else

  res.send "Hi"


server.listen 63833
