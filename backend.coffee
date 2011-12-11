redis = require('redis')

client = redis.createClient()
client.on 'error', (err) ->
  console.log err

module.exports =
  user_joined: (username, channel) =>
    client.sadd 'users_with_data', username
    client.sadd 'users_online', username
    client.rpush "history:#{username}", JSON.stringify([1, parseInt(Date.now()/60000)])

  user_quit: (username, channel) =>
    client.sadd 'users_with_data', username
    client.srem 'users_online', username
    client.rpush "history:#{username}", JSON.stringify([0, parseInt(Date.now()/60000)])

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


process.on 'SIGTERM', ->
  console.log("Marking all users as offline")
  module.exports.users_online (users) ->
    for user in users
      module.exports.user_quit user, '#foobar'
      console.log "Marking #{user} as offline"
