gpio = require("gpio")
pins = require("#{__dirname}/pins")

# Top level functions are general purpose
module.exports = {
  on: (num) ->
    pin = gpio.export num, {
      ready: () ->
        do pin.set
    }
  off: (num) ->
    pin = gpio.export num, {
      ready: () ->
        do pin.reset
    }
}

module.exports.flash = (num, timeon) =>
  module.exports.on num
  setTimeout () ->
    module.exports.off num
  , timeon

module.exports.delayed_flash = (num, wait, timeon) =>
  setTimeout () ->
    module.exports.flash(num, timeon)
  , wait

# Then for each color we define these functions again... syntax sugar
# Lets us do: lights.red.flash 1000 or lights.red.on
for light, pin of pins.lights
  do (module, light, pin) ->
    module.exports[light] = {
      on: () =>
        module.exports.on pin

      off: () =>
        module.exports.off pin

      flash: (time) =>
        module.exports.flash pin, time

      delayed_flash: (wait, time) =>
        module.exports.delayed_flash pin, wait, time
    }
