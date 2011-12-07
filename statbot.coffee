#!/usr/bin/env coffee

irc     = require('irc')
express = require('express')

records =
  '#elementary-web': {}
  '#ruby': {}
  '#kittybot': {}

client = new irc.Client 'irc.freenode.net', 'statbot'
  channels: ['#kittybot', '#ruby'] #['#elementary-web', '#ruby', '#kittybot']

client.addListener 'join', (channel, nick, message) ->
  records[channel][nick] = [] unless records[channel][nick]

  data =
    action:'join'
    date: Date.now()
  records[channel][nick].push data

  console.log "#{nick} joined #{channel}"

client.addListener 'part', (channel, nick, reason, message) ->
  records[channel][nick] = [] unless records[channel][nick]

  data =
    action:'part'
    date: Date.now()
  records[channel][nick].push data

  console.log "#{nick} left #{channel}"

client.addListener 'message', (from, to, message) ->
  if message == '!printlogs'
    console.log JSON.stringify(records)


app = express.createServer()

app.get '/', (req, res) ->
  res.send('Hello world!')

app.listen 80

console.log 'Started!'
