counters = {}

verify_existence_of = (name) ->
  counters[name] = 0 unless counters[name]

module.exports =
  get: (name) ->
    verify_existence_of name
    counters[name]

  incr: (name) ->
    verify_existence_of name
    counters[name] += 1

  decr: (name) ->
    verify_existence_of name
    counters[name] -= 1

  names: ->
    name for name, _ of counters
