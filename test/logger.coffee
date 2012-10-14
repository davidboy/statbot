assert = require 'assert'
sinon  = require 'sinon'
events = require 'events'

describe 'the logger module', ->
  before ->
    @fake_bot = new events.EventEmitter
    require('../src/modules/logger')(@fake_bot)

  beforeEach ->
    console.log = sinon.stub()

  afterEach ->
    console.log.reset()

  describe 'on a join event', ->
    it 'logs the event to the console', ->
      @fake_bot.emit 'join', 'davidboy'
      assert console.log.calledWith 'davidboy joined'

  describe 'on a quit event', ->
    it 'logs the event to the console', ->
      @fake_bot.emit 'quit', 'davidboy'
      assert console.log.calledWith 'davidboy left'
