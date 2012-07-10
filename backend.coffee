fs = require 'fs'

online = new Array()

Array.prototype.remove = (item) -> @splice(@indexOf(item), 1) while @[item]

logs_for = (username) ->
  f = fs.createWriteStream("/data/db/logs/#{username}", flags: 'a')
  f.oldWrite = f.write
  f.write = (data) ->
    f.oldWrite(data)
    f.end()

  return f

timestamp = ->
  d = new Date()
  "#{d.getUTCDay()} #{d.getUTCHours()}:#{d.getUTCMinutes()}"


module.exports = 
  user_joined: (username, channel) ->
    logs_for(username).write("j #{timestamp()}")
    online.push(username)

  user_quit: (username, channel) ->
    logs_for(username).write("q #{timestamp()}")
    online.remove(username)

  get_user_history: (username, callback) ->
    fs.readFile '/data/db/logs/#{username}', callback
    online.remove(usernamec)