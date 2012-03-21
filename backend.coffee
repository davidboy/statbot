redis = require 'redis'
client = redis.createClient()

client.on 'error', (err) ->
  console.log "Redis Error: #{err}"

current_day = ->
  d = new Date()
  d.getUTCDay()

current_hour = ->
  d = new Date()
  d.getUTCHours()

current_minute = ->
  d = new Date()
  d.getUTCMinutes()

current_timestamp = ->
  "#{current_day()} #{current_hour()}:#{current_minute()}"

module.exports =
  client: client

  user_joined: (username, channel) =>
    client.sadd 'users_with_data', username
    client.sadd 'users_online', username
    client.lpush "history:#{username}", "j #{current_timestamp()}"

  user_quit: (username, channel) =>
    client.sadd 'users_with_data', username
    client.srem 'users_online', username
    client.lpush "history:#{username}", "q #{current_timestamp()}"

  tick: ->
    client.incr "total_mins:#{current_day()}:#{current_hour()}"
    module.exports.get_users_online (users) ->
      client.incr("#{user}:#{current_day()}:#{current_hour()}") for user in users

  get_probability_for_user: (username, day, hour, callback) ->
    client.get "#{username}:#{day}:#{hour}", (err, user_online_mins) =>
      client.get "total_mins:#{day}:#{hour}", (err, total_mins) =>
        callback(parseInt(parseInt(user_online_mins) / parseInt(total_mins) * 100))

  get_user_history: (username, callback) ->
    console.log "history:#{username}"
    client.lrange "history:#{username}", 0, -1, (err, history) ->
      callback(history.reverse())

  get_users_with_data: (callback) =>
    client.smembers 'users_with_data', (err, results) =>
      callback(results)

  get_users_online: (callback) =>
    client.smembers 'users_online', (err, results) =>
      callback(results)

setInterval(module.exports.tick, 60000)

process.on 'SIGTERM', ->
  console.log("Marking all users as offline")
  module.exports.get_users_online (users) ->
    for user in users
      module.exports.user_quit user, '#foobar'
      console.log "Marking #{user} as offline"
