module.exports =
  day: ->
    d = new Date()
    d.getUTCDay()

  hour: ->
    d = new Date()
    d.getUTCHours()

  minute: ->
    d = new Date()
    d.getUTCMinutes()

  timestamp: ->
    "#{module.exports.day()} #{module.exports.hour()}:#{module.exports.minute()}"
