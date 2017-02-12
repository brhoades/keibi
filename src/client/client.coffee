gpio = require("./gpio")
pins = require("./pins")
lights = require("./lights").init(gpio)
utils = require("./utils")
speaker = require("./spkr").init(gpio)

# initialize state
state = require("./state")

gpio.in pins.switch, utils.buffer_input_fn(1000, ->
  do state.toggle
)

gpio.in pins.motion1, utils.buffer_input_fn(550, ->
  do state.trip
)
