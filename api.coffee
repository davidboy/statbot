express = require 'express'
users   = require './users'
counter = require './util/counter'

app     = express.createServer express.logger()
app.set('view engine', 'ejs')
app.set('views', __dirname)

flatten = (a) -> Array.prototype.concat.apply([], a)

app.get '/users/all/', (req, res) ->
  res.write(user + "\n") for user in users.all()
  res.end()

app.get '/users/online/', (req, res) ->
  res.write(user + "\n") for user in users.online()
  res.end()

app.get '/counters/all/', (req, res) ->
  res.write(name + "\n") for name in counter.names()
  res.end()

app.get '/probability/:username/:day/:hour/', (req, res) ->
  res.send users.find(req.params.username).online_probability_on(req.params.day, req.params.hour).toString()

app.get '/probability/:username/', (req, res) ->
  res.send JSON.stringify flatten users.find(req.params.username).online_probability()

app.get '/chart/:username/', (req, res) ->
  res.render 'index.ejs',
    layout: false
    username: req.params.username
    xs:       flatten(i for i in [0..24] for _ in [1..7])
    ys:       flatten(i for i in [1..7] for _ in [1..24])
    data:     JSON.stringify flatten users.find(req.params.username).online_probability()

module.exports = app
