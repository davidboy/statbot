express = require 'express'
flatten = require '../util/flatten'

module.exports = (bot) ->
  bot.api = express.createServer express.logger()

  bot.api.get '/probability/:username/', (req, res) ->
    res.send JSON.stringify flatten bot.find_user(req.params.username).online_probability()

  bot.api.get '/:username/', (req, res) ->
    res.render __dirname + '/../../views/index.ejs',
      layout: false
      username: req.params.username
      data:     JSON.stringify flatten bot.find_user(req.params.username).online_probability()
      currently_online: req.params.username in bot.online_users()

  port = process.env.PORT || 3000
  bot.api.listen port, ->
    console.log "API server started on port #{port}"
