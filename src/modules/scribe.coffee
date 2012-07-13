counter = require '../util/counter'
current = require '../util/helpers'

module.exports = (bot) ->
  bot.on 'tick', ->
    timestamp = "#{current.day()}:#{current.hour()}"
    counter.incr "total_mins:#{timestamp}"

    for user in bot.online_users()
      counter.incr "#{user}:#{timestamp}"
