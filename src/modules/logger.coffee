module.exports = (bot) ->
  bot.on 'join', (nick) ->
    console.log "#{nick} joined"

  bot.on 'quit', (nick) ->
    console.log "#{nick} left"
