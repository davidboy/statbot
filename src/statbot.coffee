events  = require 'events'
config  = require './config'
bot     = new events.EventEmitter()

for module in config.statbot.modules
  require("./modules/#{module}")(bot, config[module])
