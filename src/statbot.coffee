events  = require('events')
bot     = new events.EventEmitter()

modules = ['irc_bot', 'ticker', 'scribe', 'users', 'prophet', 'api', 'logger', 'persistence']

for module in modules
  require("./modules/#{module}")(bot)
