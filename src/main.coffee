gpio = require("gpio")
pins = require("#{__dirname}/pins")
lights = require("#{__dirname}/lights")
# speaker = require("#{__dirname}/spkr")

# initialize state
state = require("#{__dirname}/state")

switch1 = gpio.export pins.switch, {
  direction: "in",
  ready: () ->
    switch1.on "change", () ->
      do state.toggle
    }

setTimeout () ->
  do state.arm
, 2000
