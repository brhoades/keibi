module.exports = {}

# Returns a wrapped function. This function has a state on it which stores
# the last time the input changed for a given delay. If the time elapsed is
# less than the provided delay, the callback isn't called. Otherwise, it is.
module.exports.buffer_input_fn = (delay, func) =>
  # our first setup is a freebee
  last_input_time = 0
  (vargs...) =>
    new_time = new Date().getTime()
    if new_time - last_input_time > delay
      last_input_time = new Date().getTime()
      func(vargs)
