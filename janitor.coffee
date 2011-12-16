backend = require('./backend')

record_statistics = ->
  console.log "Recording statistics..."
  backend.record_minute()
  backend.users_online (users) ->
    for user in users
      backend.user_is_online(user)

setInterval(record_statistics, 60000)


process.on 'SIGTERM', ->
  console.log("Marking all users as offline")
  backend.users_online (users) ->
    for user in users
      backend.user_quit user, '#foobar'
      console.log "Marking #{user} as offline"
