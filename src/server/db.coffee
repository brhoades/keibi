Schema = require 'bookshelf-schema'
knex = require('knex')({
  dialect: 'sqlite3'
  connection: {
    filename: './main.db'
  }
})
db = require('bookshelf')(knex)
db.plugin Schema()

{HasOne} = require 'bookshelf-schema/lib/relations'


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
  knex.schema.createTableIfNotExists('client', (table) ->
    console.log "Creating client table."
    do table.increments

    table.string 'name'
    table.string 'uuid'
    table.string 'secret'
    do table.timestamps
  ).then(->)

  knex.schema.createTableIfNotExists('log', (table) ->
    console.log "Creating log table."
    do table.increments

    table.json 'message'
    table.integer('client_id').unsigned

    table.foreign('client_id').references('client.id')
    do table.timestamps
  ).then(->)
  this
