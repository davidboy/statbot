express = require('express')
backend = require('./backend')

app = express.createServer(express.logger())

app.get '/users/all/', (req, res) ->
  backend.get_users_with_data (users) ->
    res.write(user + "\n") for user in users
    res.end()

app.get '/users/online/', (req, res) ->
  backend.get_users_online (users) ->
    res.write(user + "\n") for user in users
    res.end()

app.get '/history/:username/', (req, res) ->
  backend.get_user_history req.params.username, (history) ->
    for item in history
      res.write item + "\n"

    res.end()

app.get '/probability/:username/:day/:hour/', (req, res) ->
  backend.get_probability_for_user req.params.username, req.params.day, req.params.hour, (prob) =>
    res.write prob.toString()
    res.end()


module.exports = app
