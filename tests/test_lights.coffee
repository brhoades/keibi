chai = require "chai"
sinon = require "sinon"

expect = chai.expect
chai.should


describe "lights", ->
  describe "#on", ->
    it "should call pin.set for that pin", ->
      stub_pin = sinon.stub({set: () -> })
      stub_gpio = sinon.stub().export.returns(stub_pin)
      lights = require("#{__dirname}/../src/lights").init(stub_gpio)

      expect(stub_gpio.export.calledOnce).to.equal true
      expect(stub_pin.set.calledOnce).to.equal true

      lights.on 1
