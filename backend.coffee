redis = require('redis')

client = redis.createClient()
client.on 'error', (err) ->
  console.log err

current_hour = ->
  d = new Date()
  d.getUTCHours()

module.exports =
  client: client

  user_joined: (username, channel) =>
    client.sadd 'users_with_data', username
    client.sadd 'users_online', username
    client.rpush "history:#{username}", JSON.stringify([1, parseInt(Date.now()/60000)])

  user_quit: (username, channel) =>
    client.sadd 'users_with_data', username
    client.srem 'users_online', username
    client.rpush "history:#{username}", JSON.stringify([0, parseInt(Date.now()/60000)])

  record_minute: ->
    client.incr "total_mins:#{current_hour()}"

  user_is_online: (username) ->
    client.incr "#{username}:#{current_hour()}"

  get_probability_for_user: (username, day, callback) ->
    client.get "#{username}:#{day}", (err, user_online_mins) =>
      client.get "total_mins:#{day}", (err, total_mins) =>
        callback(parseInt(parseInt(user_online_mins) / parseInt(total_mins) * 100))

  users_with_data: (callback) =>
    client.smembers 'users_with_data', (err, results) =>
      callback(results)

  users_online: (callback) =>
    client.smembers 'users_online', (err, results) =>
      callback(results)

  each_event_during_week: (username, requested_week, callbacks) ->
    client.lrange "history:#{username}", 0, -1, (err, results) ->
      for event in results
        event = JSON.parse(event)
        week = parseInt(parseInt(event[1]) / 10080)
        date = new Date(parseInt(event[1]) * 60000)

        if week == requested_week
          code = 'q'
          if parseInt(event[0]) == 1
            code = 'j'

          day = date.getUTCDay()
          timestamp = "#{date.getUTCHours()}:#{date.getUTCMinutes()}"

          callbacks.for_each(code, day, timestamp)

      callbacks.on_finished()
