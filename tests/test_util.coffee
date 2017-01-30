chai = require "chai"
util = require "#{__dirname}/../src/utils.coffee"
expect = chai.expect

describe "util", ->
  it "should have buffer_input_fn method", ->
    expect util.buffer_input_fn != undefined
