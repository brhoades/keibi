restify = require "restify"
db = require "#{__dirname}/db"

utils = require "#{__dirname}/utils"

server = do restify.createServer

# initial connection
# sends a secret back which must be included in all future queries
server.get "/handshake/:client", (req, res, next) ->
  client_id = req.params.client
  secret = utils.random_id 21
  res.send {
    secret: secret
  }

server.get "/:event/:client/:secret", (req, res, next) ->
  secret = req.params.secret
  client_id = req.params.client
  time = new Date().getTime

  # TODO: Client timeout
  switch req.params.event
    when "keep-alive" then
    when "arm" then
    when "trigger" then
    when "disarm" then
    when "disassoc" then


server.listen 63833
