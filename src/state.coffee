lights = require("#{__dirname}/lights")

class State
  constructor: () ->
    @states = {
      DISARMED: 0,
      ARMED: 1,
      TRIPPED: 2,
      ALARM: 3
    }

    @state =  null
    @lastchange = new Date().getTime()
    @change_delay = 1000

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
    if @state == @states.ARMED or not this._delay_elapsed()
      return
    # TODO timeout w/ flash / beep

    do lights.green.off
    do lights.red.on
    console.log "ARMED"

    @state = @states.ARMED
    @lastchange = new Date().getTime()

  disarm: () ->
    if @state == @states.DISARMED or not this._delay_elapsed()
      return

    do lights.red.off
    do lights.green.on
    console.log "DISARMED"

    @state = @states.DISARMED
    @lastchange = new Date().getTime()

  _delay_elapsed: () ->
    return new Date().getTime() - @lastchange > @change_delay


module.exports = (new State())
