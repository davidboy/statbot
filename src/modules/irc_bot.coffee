irc = require 'irc'

module.exports = (bot) ->
  client = new irc.Client 'irc.freenode.net', 'statbot'
    channels: ['#kittybot']#, '#elementary', '#elementary-dev', '#elementary-web']
  
  client.on 'join', (channel, nick, message) ->
    bot.emit 'join', nick
  
  client.on 'part', (channel, nick, reason, message) ->
    bot.emit 'quit', nick

  client.on 'quit', (nick, reason, channel) ->
    bot.emit 'quit', nick

  client.on 'names', (channel, nicks) ->
    for nick, perms of nicks
      bot.emit 'join', nick
