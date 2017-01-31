Schema = require 'bookshelf-schema'
knex = require('knex')({
  client: "sqlite3",
  connection: {
    database: "main.sqlite3"
  }
})
db = require('bookshelf')(knex)
db.plugin Schema()

{StringField, DateTimeField, JSONField} = require 'bookshelf-schema/lib/fields'
{HasOne} = require 'bookshelf-schema/lib/relations'

class Client extends db.Model
  tableName: 'client'
  @schema [
    StringField 'clientname'
    StringField 'secret'
  ]

class Log extends db.Model
  tableName: 'log'
  @schema [
    StringField 'client_id'
    DateTimeField 'time'
    JSONField 'message'

    HasOne Client
  ]
