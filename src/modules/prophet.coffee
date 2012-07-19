counter = require '../util/counter'

module.exports = (bot) ->
  bot.find_user = (username) ->
    online_probability_on: (day, hour) ->
      user_online_mins = counter.get "#{username}:#{day}:#{hour}"
      total_mins       = counter.get "total_mins:#{day}:#{hour}"
      parseInt(user_online_mins / total_mins * 100) or 0

    online_probability: ->
      @online_probability_on(day, hour) for hour in [0..23] for day in [1..7]
