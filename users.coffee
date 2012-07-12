current = require './util/helpers'
counter = require './util/counter'

users_online = {}

#backup = ->
#  return



module.exports =
  online: ->
    username for username, online of users_online when online

  all: ->
    username for username, online of users_online

  #TODO: There must be a better way to do this.
  count: ->
    sum=0;
    for username, online of users_online
      sum += 1 if online

    sum

  find: (username) ->
    joined: ->
      users_online[username] = true

    quit: ->
      users_online[username] = false

    online_probability_on: (day, hour) ->
      user_online_mins = counter.get "#{username}:#{day}:#{hour}"
      total_mins       = counter.get "total_mins:#{day}:#{hour}"
      parseInt(user_online_mins / total_mins * 100) or 0

    online_probability: ->
      @online_probability_on(day, hour) for hour in [1..24] for day in [1..7]

tick = =>
  console.log "Running checkins for #{module.exports.count()} users"
  counter.incr "total_mins:#{current.day()}:#{current.hour()}"

  for user in module.exports.online()
    counter.incr "#{user}:#{current.day()}:#{current.hour()}"

setInterval(tick, 60000)
#setInterval(backup, 120000)
