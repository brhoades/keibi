# Max size of 21
random_id = (size) ->
  (Math.random()*1e32).toString(36).substring(0, size)

# Append a success key on if there isn't one
respond = (res, message) ->
  if "success" not in message
    message["success"] = true

  res.send message

module.exports = {
  random_id: random_id
  respond: respond
}
