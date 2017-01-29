gpio = require("gpio")
EventEmitter = require('events').EventEmitter
pins = require("#{__dirname}/pins")

# Dumb testin function
gpioexec = (num) =>
  pin = gpio.export num, {
    ready: () =>
      repeatme = () =>
        do pin.set
        console.log "#{num} ON"

        setTimeout () =>
          console.log "#{num} OFF"
          do pin.reset
          setTimeout repeatme, 1000
        , 1000

      do repeatme
}

gpioexec pins.blue_led
gpioexec pins.green_led
