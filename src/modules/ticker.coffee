module.exports = (bot) ->
  tick = =>
    bot.emit 'tick'

  setInterval(tick, 60000)
