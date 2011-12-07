#!/usr/bin/env coffee

irc     = require('irc')
express = require('express')

users = {}

app = express.createServer(express.logger())

app.get '/', (req, res) ->
  res.send(JSON.stringify(users))

app.get '/:username', (req, res) ->
  username = req.params.username
  data = users[username]

  for timestamp, action in data.history
    res.write(timestamp + '\n')
    res.end()

port = process.env.PORT || 3000
app.listen port, ->
  console.log "Listening on #{port}"


client = new irc.Client 'irc.freenode.net', 'statbot'
  channels: ['#kittybot', '#ruby'] #['#elementary-web', '#ruby', '#kittybot']

client.addListener 'join', (channel, nick, message) ->
  users[nick] = {online: false, history: {}} unless users[nick]

  # Don't record them as joining if they are already online
  unless users[nick].online
    users[nick].online = true
    users[nick].history[parseInt(Date.now())] = 'join'
    console.log "#{nick} joined #{channel}"
  else
    console.log "#{nick} joined #{channel}, recording skipped because he was already online"


client.addListener 'part', (channel, nick, reason, message) ->
  users[nick] = {online: false, history: {}} unless users[nick]

  # Only record them as leaving if they are online
  if users[nick].online
    users[nick].online = false
    users[nick].history[parseInt(Date.now())] = 'part'
    console.log "#{nick} left #{channel}"
  else
    console.log "#{nick} left #{channel}, recording skipped because he was already offline"

