bcrypt = require "bcrypt"
knex = require('knex')({
  dialect: 'sqlite3'
  connection: {
    filename: './main.db'
  }
})
db = require('bookshelf')(knex)

utils = require "./utils"


class Client extends db.Model
  tableName: 'client'

class Log extends db.Model
  tableName: 'log'
  client: () ->
    @belongsTo Client

class State extends db.Model
  tableName: 'state'
  client: () ->
    @belongsTo Client

class Event extends db.Model
  tableName: 'event'
  client: () ->
    @belongsTo Client

module.exports = {
  client: Client
  log: Log
  state: State
  event: Event
}

module.exports.init = ->
  # Model Schema
  db.knex.schema.createTableIfNotExists('client', (table) ->
    do table.increments

    table.string 'name'
    table.string 'secret_hash'
    do table.timestamps
  ).then()

  db.knex.schema.createTableIfNotExists('log', (table) ->
    do table.increments

    table.json 'message'
    table.integer('client_id').unsigned

    table.foreign('client_id').references('client.id')
    do table.timestamps
  ).then()

  db.knex.schema.createTableIfNotExists('state', (table) ->
    do table.increments

    table.boolean 'armed'
    table.integer('client_id').unsigned

    table.foreign('client_id').references('client.id')
    do table.timestamps
  ).then()

  db.knex.schema.createTableIfNotExists('event', (table) ->
    do table.increments

    table.string('type')
    table.integer('client_id').unsigned

    table.foreign('client_id').references('client.id')
    do table.timestamps
  ).then()
  this

# Calls res if invalid. Returns client.
module.exports.authenticate = (res, req, next, cb) ->
  if not req.params.id or  not req.params.secret
    module.exports.respond res, {
      success: false
      message: "id and secret are required"
    }
    return next()

  Client.where("id", req.params.id).fetch().then (client) ->
    if not client
      utils.respond res, {
        success: false
        message: "Client not found for id #{req.params.id}"
      }
      return next()
    else if not bcrypt.compareSync req.params.secret, client.get("secret_hash")
      utils.respond res, {
        success: false
        message: "Bad secret"
      }
      return next()
    else
      cb client
