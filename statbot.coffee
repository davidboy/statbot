#!/usr/bin/env coffee
irc_bot    = require('./irc_bot')
api_server = require('./api')

irc_bot.start()
api_server.listen(process.env.PORT || 3000)

