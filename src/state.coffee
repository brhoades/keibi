lights = require("#{__dirname}/lights")
speaker = require("#{__dirname}/spkr")

class State
  constructor: () ->
    @states = {
      DISARMED: 0,
      ARMED: 1,
      TRIPPED: 2,
      ALARM: 3
    }

    @state =  null

    duration = 100
    # Startup
    for x in [0, 3, 7]
      do () ->
        lights.blue.delayed_flash (x*duration), duration
        lights.green.delayed_flash ((x+1)*duration), duration
        lights.yellow.delayed_flash ((x+2)*duration), duration
        lights.red.delayed_flash ((x+3)*duration), duration

  # Toggle between armed and disarmed properly
  toggle: () ->
    if @state == @states.DISARMED
      do this.arm
    else
      do this.disarm

  arm: () ->
    if @state == @states.ARMED
      return
    # TODO timeout w/ flash / beep

    do lights.green.off
    do lights.red.on
    console.log "ARMED"

    @state = @states.ARMED

    speaker.buzz 500

  disarm: () ->
    if @state == @states.DISARMED
      return

    do lights.red.off
    do lights.green.on
    console.log "DISARMED"

    @state = @states.DISARMED

    speaker.buzz 250
    setTimeout () ->
      speaker.buzz 250
    , 500


module.exports = (new State())
