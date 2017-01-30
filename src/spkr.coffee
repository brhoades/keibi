gpio = require("gpio")
pins = require("#{__dirname}/pins")

module.exports = {
  on: () ->
    console.log "BUZZ"
    pin = gpio.export pins.speaker, {
      ready: () ->
        do pin.set
    }
  off: () ->
    console.log "BUZZ OFF"
    pin = gpio.export pins.speaker, {
      ready: () ->
        do pin.reset
    }
}

module.exports["buzz"] = (duration) ->
  do module.exports.on
  setTimeout () ->
    do module.exports.off
  , duration
