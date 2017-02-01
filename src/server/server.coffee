restify = require "restify"
bcrypt = require "bcrypt"
db = require("./db").init()

utils = require "./utils"

server = restify.createServer()

# initial connection
# sends a secret back which must be included in all future queries
server.get "/handshake/:name", (req, res, next) ->
  name = req.params.name
  secret = utils.random_id(32)
  secret_hash = bcrypt.hashSync secret

  client = new db.client({
    name: name
    secret_hash: secret_hash
  }).save().then (client) ->
    utils.respond res, {
        id: client.id
        name: name
        secret: secret
    }

server.get "/event/:event/:id/:secret", (req, res, next) ->
  secret = req.params.secret
  id = req.params.id
  time = new Date().getTime()

  # TODO: Client timeout
  switch req.params.event
    when "keep-alive"
      db.authenticate res, req, next, (client) ->
        utils.respond res
        return next()
    when "arm" then
    when "trigger" then
    when "disarm" then
    when "disassoc" then
    else
      utils.respond res, {
        success: false
      }
      return next()



server.listen 63833
