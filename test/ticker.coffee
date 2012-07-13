assert  = require 'assert'
sinon   = require 'sinon'
events  = require 'events'

refute = (thing) -> not thing

describe 'the ticker module', ->
  bot = clock = null

  beforeEach ->
    bot   = new events.EventEmitter()
    clock = sinon.useFakeTimers(Date.UTC(2012, 1, 1))

    sinon.spy bot, 'emit'

    require('../src/modules/ticker')(bot)

  afterEach ->
    bot.emit.restore()
    clock.restore()

  it 'fires every minute', ->
    clock.tick 60000
    assert bot.emit.calledWith 'tick'

  it 'won\'t fire before a minute is passed', ->
    clock.tick 59000
    refute bot.emit.calledWith 'tick'
