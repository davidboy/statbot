irc    = require 'irc'
users  = require './users'
user   = users.find

client = null

module.exports =
  start: ->
    client = new irc.Client 'irc.freenode.net', 'statbot'
      channels: ['#kittybot']#, '#elementary', '#elementary-dev', '#elementary-web']

    client.addListener 'join', (channel, nick, message) ->
      user(nick).joined()
      console.log "#{nick} joined #{channel}"

    client.addListener 'part', (channel, nick, reason, message) ->
      user(nick).quit()
      console.log "#{nick} left #{channel}"

    client.addListener 'quit', (nick, reason, channel) ->
      user(nick).quit()
      console.log "#{nick} quit"

    client.addListener 'names', (channel, nicks) ->
      for nick, _ of nicks
        user(nick).joined()
        console.log "Marking #{nick} as online"

process.on 'SIGTERM', ->
  console.log 'Marking all users as offline'
  for user in users.online()
    module.exports.user_quit user, '#foobar'
