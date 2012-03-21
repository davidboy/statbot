irc     = require('irc')
backend = require('./backend')

client = {}

module.exports =
  start: ->
    client = new irc.Client 'irc.freenode.net', 'statbot2'
      channels: ['#kittybot']

    client.addListener 'join', (channel, nick, message) ->
      backend.user_joined(nick, channel)
      console.log "#{nick} joined #{channel}"

    client.addListener 'part', (channel, nick, reason, message) ->
      backend.user_quit(nick, channel)
      console.log "#{nick} left #{channel}"

    client.addListener 'quit', (nick, reason, channel) ->
      backend.user_quit(nick, channel)
      console.log "#{nick} quit"

    client.addListener 'names', (channel, nicks) ->
      for nick, perms of nicks
        console.log "Marking #{nick} as online"
        backend.user_joined(nick, channel)


