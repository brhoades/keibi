lights = require("/lights").init(require("gpio"))
speaker = require "./spkr"

events = require "events"

class State
  constructor: () ->
    @states = {
      DISARMED: 0
      ARMED: 1
      TRIPPED: 2
      ALARM: 3
    }

    # Time between a detected move and an alarm
    @ALARM_BUFFER_TIME = 30000

    @state =  null
    @eventEmitter = new events.EventEmitter()

    duration = 100
    sum = 0
    # Startup
    for x in [0..3]
      for light in [lights.blue, lights.green, lights.yellow, lights.red]
        light.delayed_flash sum, duration
        sum += duration

    do this.register_handlers
    do this.arm

  # Toggle between armed and disarmed properly
  toggle: () ->
    if @state == @states.DISARMED
      do this.arm
    else
      do this.disarm

  arm: () ->
    if @state == @states.ARMED
      return

    @eventEmitter.emit @states.ARMED

  arm_handler: () ->
    # TODO timeout w/ flash / beep
    do lights.green.off
    do lights.red.on
    console.log "ARMED"

    speaker.buzz 150, 500, 150
    @state = @states.ARMED

  disarm: () ->
    if @state == @states.DISARMED
      return

    @eventEmitter.emit @states.DISARMED

  disarm_handler: () ->
    do lights.red.off
    do lights.green.on
    console.log "DISARMED"

    speaker.buzz 250
    @state = @states.DISARMED

  trip: () ->
    lights.yellow.flash 600
    if @state != @states.ARMED
      #TODO: If we're triggered, still log
      return

    @eventEmitter.emit @states.TRIPPED

  trip_handler: () ->
    @state = @states.TRIPPED
    @eventEmitter.emit @states.TRIPPED
    console.log "TRIPPED"

    # Fire a warning buzz, then countdown.
    speaker.buzz 250, 500, 250, 500, 250, () ->
    # If we're still tripped
      start = new Date().getTime()
      alarm = new Promise (resolve, reject) ->
        setTimeout () ->
          @alarm alarm,

          @eventEmitter.emit @states.ALARM
        , @ALARM_BUFFER_TIME

      @eventEmitter.on @states.DISARMED, () ->





  register_handlers: () ->
    @eventEmitter.on @states.ARMED, @arm_handler
    @eventEmitter.on @states.DISARMED, @disarm_handler
    @eventEmitter.on @states.TRIPPED, @trip_handler





module.exports = (new State())
