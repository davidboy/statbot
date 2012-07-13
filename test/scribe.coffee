events  = require 'events'
assert  = require 'assert'
counter = require '../src/util/counter'
sinon   = require 'sinon'

describe 'the scribe module', ->
  bot = clock = null

  before ->
    counter.wipe()

    bot = new events.EventEmitter()

    # We're faking these functions so that `scribe` will have access to the 
    #   user lists without having to load the `user` module.
    bot.all_users = ->
      ['davidboy', 'khampal']

    bot.online_users = ->
      ['davidboy']

    require('../src/modules/scribe')(bot)

  beforeEach ->
    clock = sinon.useFakeTimers(Date.UTC(2012, 1, 1))

  afterEach ->
    counter.wipe()
    clock.restore()

  it 'increments the total seconds counter for the current day and hour', ->
    assert.equal 0, counter.get 'total_mins:3:0'
    bot.emit 'tick'
    assert.equal 1, counter.get 'total_mins:3:0'


  it 'increments the seconds seen counter for each online user', ->
    assert.equal 0, counter.get 'davidboy:3:0'
    bot.emit 'tick'
    assert.equal 1, counter.get 'davidboy:3:0'

  it 'doesn\'t increment any counters for a users who\'s offline', ->
    assert.equal 0, counter.get 'khampal:3:0'
    bot.emit 'tick'
    assert.equal 0, counter.get 'khampal:3:0'
