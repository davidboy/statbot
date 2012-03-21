#!/usr/bin/env coffee
irc_bot    = require('./irc_bot')
api_server = require('./api')

irc_bot.start()

port = process.env.PORT || 3000
api_server.listen port, ->
  console.log "API server started on port #{port}"
