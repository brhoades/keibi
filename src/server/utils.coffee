# Max size of 21
random_id = (size) ->
  (Math.random()*1e32).toString(36).substring(0, size)

module.exports = {
  random_id: random_id
}
