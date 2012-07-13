fs      = require 'fs'
counter = require '../util/counter'

module.exports = (bot) ->
  counter.wipe()
  data = JSON.parse fs.readFileSync 'data/counters'
  counter.set name, value for name, value of data

  bot.on 'tick', ->
    data = {}
    data[name] = counter.get name for name in counter.names()
    fs.writeFile 'data/counters', JSON.stringify(data), (err) ->
      throw err if err
