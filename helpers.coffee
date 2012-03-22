module.exports =
  day = ->
    d = new Date()
    d.getUTCDay()

  hour = ->
    d = new Date()
    d.getUTCHours()

  minute = ->
    d = new Date()
    d.getUTCMinutes()

  timestamp = ->
    "#{current_day()} #{current_hour()}:#{current_minute()}"
