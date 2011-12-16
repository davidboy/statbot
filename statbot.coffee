#!/usr/bin/env coffee
irc_bot    = require('./irc_bot')
api_server = require('./api')
require('./janitor')

irc_bot.start()
api_server.listen(process.env.PORT || 3000)

