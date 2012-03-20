#!/usr/bin/env coffee
irc_bot    = require('./irc_bot')
api_server = require('./api')

irc_bot.start()
api_server.listen(process.env.PORT || 3000)

process.on 'SIGTERM', ->
  console.log("Marking all users as offline")
  backend.users_online (users) ->
    for user in users
      backend.user_quit user, '#foobar'
      console.log "Marking #{user} as offline"
