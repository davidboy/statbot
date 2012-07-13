users_online = {}

module.exports = (bot) ->
  bot.on 'join', (username) ->
    users_online[username] = true

  bot.on 'quit', (username) ->
    users_online[username] = false

  bot.online_users = ->
    username for username, online of users_online when online

  bot.all_users = ->
    username for username, _ of users_online
