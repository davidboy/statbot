client = require('redis').createClient()

current_hour = ->
  d = new Date()
  d.getUTCHours()

module.exports =
  client: client

  user_joined: (username, channel) =>
    client.sadd 'users_with_data', username
    client.sadd 'users_online', username

  user_quit: (username, channel) =>
    client.sadd 'users_with_data', username
    client.srem 'users_online', username

  tick: ->
    client.incr "total_mins:#{current_hour()}"
    module.exports.get_users_online (users) ->
      client.incr("#{user}:#{current_hour()}") for user in users

  get_probability_for_user: (username, hour, callback) ->
    client.get "#{username}:#{hour}", (err, user_online_mins) =>
      client.get "total_mins:#{hour}", (err, total_mins) =>
        callback(parseInt(parseInt(user_online_mins) / parseInt(total_mins) * 100))

  get_users_with_data: (callback) =>
    client.smembers 'users_with_data', (err, results) =>
      callback(results)

  get_users_online: (callback) =>
    client.smembers 'users_online', (err, results) =>
      callback(results)

setInterval(module.exports.tick, 60000)
