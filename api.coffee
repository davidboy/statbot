express = require('express')
backend = require('./backend')

app = express.createServer()#express.logger())

app.get '/users/all/basic.txt', (req, res) ->
  backend.users_with_data (users) ->
    for user in users
      res.write user + "\n"

    res.end()

app.get '/users/online/basic.txt', (req, res) ->
  backend.users_online (users) ->
    for user in users
      res.write user + "\n"

    res.end()

app.get '/:week_id/:username/basic.txt', (req, res) ->
  backend.each_event_during_week req.params.username, parseInt(req.params.week_id),
    for_each: (code, day, timestamp) ->
      res.write("#{code} #{day} #{timestamp}\n")
    on_finished: ->
      res.end()

app.get '/probability/:username/:hour', (req, res) ->
  backend.get_probability_for_user req.params.username, req.params.hour, (prob) =>
    res.write prob.toString()
    res.end()


module.exports = app
