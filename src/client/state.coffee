gpio = require("./gpio")

lights = require("./lights").init(gpio)
speaker = require("./spkr").init(gpio)

events = require "events"


class State
  constructor: ->
    @states = {
      DISARMED: 0
      ARMED: 1
      TRIPPED: 2
      ALARM: 3
    }

    # Time between a detected move and an alarm
    @ALARM_BUFFER_TIME = 10000

    @state =  null
    @eventEmitter = new events.EventEmitter()

    duration = 100
    sum = 0
    # Startup
    for x in [0..3]
      for light in [lights.blue, lights.green, lights.yellow, lights.red]
        light.delayed_flash sum, duration
        sum += duration

    thisstate = this
    setTimeout ->
      do thisstate.register_handlers
      do thisstate.arm
    , sum

  # Toggle between armed and disarmed properly
  toggle: ->
    if @state == @states.DISARMED
      do this.arm
    else
      do this.disarm

  arm: ->
    if @state == @states.ARMED
      return

    @eventEmitter.emit @states.ARMED

  arm_handler: ->
    # TODO timeout w/ flash / beep
    do lights.green.off
    do lights.red.on
    console.log "ARMED"

    speaker.buzz 150, 500, 150
    @state = @states.ARMED

  disarm: ->
    if @state == @states.DISARMED
      return

    @eventEmitter.emit @states.DISARMED

  disarm_handler: ->
    do lights.red.off
    do lights.green.on
    console.log "DISARMED"

    speaker.buzz 250
    @state = @states.DISARMED

  trip: ->
    lights.yellow.flash 500
    console.log "--> TRIP"
    if @state != @states.ARMED
      #TODO: If we're triggered, still log
      return

    console.log "TRIP"
    @eventEmitter.emit @states.TRIPPED

  trip_handler: ->
    @state = @states.TRIPPED
    console.log "TRIPPED"
    thisstate = this

    # Fire a warning buzz, then countdown.
    speaker.buzz 250, 500, 250, 500, 250

    do () ->
      # If we're still tripped

      start = new Date().getTime()
      setTimeout ->
        # Fire alarm if we're still tripped after the buffer time.
        thisstate.eventEmitter.emit thisstate.states.ALARM
      , thisstate.ALARM_BUFFER_TIME

      thisstate.eventEmitter.on thisstate.states.DISARMED, ->
        console.log "DISARMED AFTER TRIP"

  alarm: ->
    if @state != @states.TRIPPED
      console.log "ALARM but not tripped, ignoring"
      return

    @eventEmitter.emit @states.ALARM

  alarm_handler: ->
    console.log "ALARM"
    @state = @states.ALARM
    scream = ->
      speaker.buzz 1000

      setTimeout scream, 1000
    do scream

  register_handlers: ->
    thisstate = this
    @eventEmitter.on @states.ARMED, ->
      do thisstate.arm_handler
    @eventEmitter.on @states.DISARMED, ->
      do thisstate.disarm_handler
    @eventEmitter.on @states.TRIPPED, ->
      do thisstate.trip_handler
    @eventEmitter.on @states.ALARM, ->
      do thisstate.alarm_handler


module.exports = (new State())
