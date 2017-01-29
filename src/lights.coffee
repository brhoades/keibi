gpio = require("gpio")
pins = require("#{__dirname}/pins")

# Top level functions are general purpose
module.exports = {
  on: (num) =>
    pin = gpio.export num, {
      ready: () ->
        do pin.set
    }
  off: (num) =>
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

# Then for each color we define these functions again... syntax sugar
# Lets us do: lights.red.flash 1000 or lights.red.on
for light, pin of pins.lights
  module.exports[light] = {
    on: () ->
      module.exports.on pin

    off: () ->
      module.exports.off pin

    flash: (time) ->
      module.exports.flash pin, time
  }
