fs      = require 'fs'
counter = require '../util/counter'

module.exports = (bot, config) ->
  counter.wipe()
  data = JSON.parse fs.readFileSync config.datafile
  counter.set name, value for name, value of data

  bot.on 'tick', ->
    data = {}
    data[name] = counter.get name for name in counter.names()
    fs.writeFile config.datafile, JSON.stringify(data), (err) ->
      throw err if err
