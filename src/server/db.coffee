bcrypt = require "bcrypt"
Schema = require "bookshelf-schema"
knex = require('knex')({
  dialect: 'sqlite3'
  connection: {
    filename: './main.db'
  }
})
db = require('bookshelf')(knex)
db.plugin Schema()

{HasOne} = require 'bookshelf-schema/lib/relations'

utils = require "./utils"


class Client extends db.Model
  tableName: 'client'

class Log extends db.Model
  tableName: 'log'
  @schema [
    HasOne Client
  ]

module.exports = {
  client: Client
  log: Log
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
