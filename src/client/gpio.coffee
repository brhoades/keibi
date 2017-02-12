# Our real GPIO library
gpio = require "gpio"


module.exports = {
  # Call the provided callback when the pin changes
  in: (pin, cb) ->
    handler = gpio.export pin, {
      direction: "in",
      ready: ->
        handler.on "change", cb
    }

  # Sets the provided pin then calls the callback
  set: (pin, cb) ->
    handler = gpio.export pin, {
      direction: "out",
      ready: ->
        handler.set
        do cb
    }

  # Resets the provided pin then calls the callback
  reset: (pin, cb) ->
    handler = gpio.export pin, {
      direction: "out",
      ready: ->
        handler.reset
        do cb
    }
}
