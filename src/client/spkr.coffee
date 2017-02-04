gpio = require "gpio"
pins = require "./pins"

module.exports = {
  on: (cb=null) ->
    console.log "BUZZ"
    pin = gpio.export pins.speaker, {
      ready: () ->
        do pin.set
        if cb
          do cb
    }
  off: (cb=null) ->
    console.log "BUZZ OFF"
    pin = gpio.export pins.speaker, {
      ready: () ->
        do pin.reset
        if cb
          do cb
    }
}

# Expects duration, delay, duration, delay... pattern.
# Always turns the speaker off when done
module.exports["buzz"] = (buzz_delay_pattern..., cb=null) ->
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
    if cb
      do cb
  , sum
