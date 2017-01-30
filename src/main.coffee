gpio = require("gpio")
pins = require("#{__dirname}/pins")
lights = require("#{__dirname}/lights")
utils = require("#{__dirname}/utils")
speaker = require("#{__dirname}/spkr")

# initialize state
state = require("#{__dirname}/state")

switch1 = gpio.export pins.switch, {
  direction: "in",
  ready: () ->
    switch1.on "change", utils.buffer_input_fn(1000, () ->
      do state.toggle
    )
}

motion1 = gpio.export pins.motion1, {
  direction: "in",
  ready: () ->
    motion1.on "change", utils.buffer_input_fn(1000, () ->
      lights.yellow.flash 1000
    )
}

setTimeout () ->
  do state.arm
, 2000
