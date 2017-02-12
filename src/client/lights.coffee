gpio = null
pins = require("./pins")


# Top level functions are general purpose
module.exports = {
  # Call first
  # Expects a /gpio.coffee-like interface in.
  init: (in_gpio) ->
    gpio = in_gpio
    this

  on: (num) ->
    gpio.set num, ->

  on: (num, cb) ->
    gpio.set num, cb

  off: (num) ->
    gpio.reset num, ->

  off: (num, cb) ->
    gpio.reset num, cb
}

module.exports.flash = (num, timeon) =>
  module.exports.on num
  setTimeout ->
    module.exports.off num
  , timeon

module.exports.delayed_flash = (num, wait, timeon) =>
  setTimeout ->
    module.exports.flash(num, timeon)
  , wait

# Then for each color we define these functions again... syntax sugar
# Lets us do: lights.red.flash 1000 or lights.red.on
for light, pin of pins.lights
  do (module, light, pin) ->
    module.exports[light] = {
      on: =>
        module.exports.on pin

      on: (cb) =>
        module.exports.on pin, cb

      off: =>
        module.exports.off pin

      off: (cb) =>
        module.exports.off pin, cb

      flash: (time) =>
        module.exports.flash pin, time

      delayed_flash: (wait, time) =>
        module.exports.delayed_flash pin, wait, time
    }
