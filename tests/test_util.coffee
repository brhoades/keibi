chai = require "chai"
util = require "#{__dirname}/../src/client/utils.coffee"

expect = chai.expect
chai.should


describe "util", ->
  describe "#buffer_input_fn", ->
    it "should take a time and a function then return a function", ->
      func = util.buffer_input_fn 1000, () ->
        true
      expect(func).to.be.a "function"

    it "should only call wrapped func once during many successive calls", ->
      internal = 0

      func = util.buffer_input_fn 1000, () ->
        internal += 1

      for i in [0..5]
        do func

      expect(internal).to.equal 1

    it "should only call wrapped func again after timeout", (done) ->
      internal = 0

      func = util.buffer_input_fn 10, () ->
        internal += 1

      do func
      do func

      setTimeout () ->
        do func
        do func

        expect(internal).to.equal 2
        do done
      , 25
