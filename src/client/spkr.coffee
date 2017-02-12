gpio = null
pins = require "./pins"

module.exports = {
  on: () ->
    console.log "BUZZ"
    gpio.set pins.speaker

  on: (cb) ->
    console.log "BUZZ"
    gpio.set pins.speaker, cb

  off: () ->
    console.log "BUZZ OFF"
    gpio.reset pins.speaker

  off: (cb) ->
    console.log "BUZZ OFF"
    gpio.reset pins.speaker, cb

  init: (in_gpio) ->
    gpio = in_gpio
    this
}

# Expects duration, delay, duration, delay... pattern.
# Always turns the speaker off when done
module.exports["buzz"] = (buzz_delay_pattern...) ->
  sum = 0

  for duration, i in buzz_delay_pattern by 2
    if i + 1 < buzz_delay_pattern.size
      delay = buzz_delay_pattern[i+1]
    else
      delay = sum + duration

    setTimeout () ->
      do module.exports.on
    , sum
    sum += duration

    setTimeout () ->
        do module.exports.off
    , sum
    sum += delay

  setTimeout () ->
    do module.exports.off
  , sum
