assert  = require 'assert'
sinon   = require 'sinon'
mockery = require 'mockery'
events  = require 'events'

config =
  server: 'irc.freenode.net'
  username: 'statbot'
  channels: ['#kittybot']

describe 'the irc_bot module', ->
  bot = client = client_creator = null

  before ->
    client = new events.EventEmitter()
    client_creator = (channel, nick, options) ->
      client

    sinon.spy client, 'on'
    client_creator = sinon.spy client_creator

    mockery.enable()
    mockery.registerAllowable '../src/modules/irc_bot'
    mockery.registerMock 'irc',
      Client: client_creator

    bot = new events.EventEmitter()

    sinon.spy bot, 'emit'

    require('../src/modules/irc_bot')(bot, config)

  after ->
    mockery.deregisterAll()
    mockery.disable()

  describe 'actual irc bot', ->
    it 'is created', ->
      assert client_creator.calledWithNew()

    it 'connects to freenode', ->
      assert client_creator.calledWith 'irc.freenode.net'

  it 'causes statbot to emit the join event when someone joins irc', ->
    client.emit 'join', '#kittybot', 'davidboy', 'hai'
    assert bot.emit.calledWithExactly 'join', 'davidboy'

  it 'causes statbot to emit the quit event when someone quits irc or leaves a channel', ->
    client.emit 'part', '#kittybot', 'davidboy', 'imad', 'bye'
    assert bot.emit.calledWithExactly 'quit', 'davidboy'

    client.emit 'quit', 'davidboy', 'imad', '#kittybot'
    assert bot.emit.calledWithExactly 'quit', 'davidboy'

  it 'marks all irc users as online when the bot starts', ->
    client.emit 'names', '#kittybot', {'khampal': 'ops', 'davidboy': 'normal'}
    assert bot.emit.calledWithExactly 'join', 'khampal'
    assert bot.emit.calledWithExactly 'join', 'davidboy'

  describe 'when a user changes their nick', ->
    beforeEach -> 
      client.emit 'nick', 'tom95', 'tom95|afk', ['#kittybot', '#elementary'], 'change!'

    it 'marks the old nick as offline', ->
      assert bot.emit.calledWithExactly 'quit', 'tom95'

    it 'marks the new nick as online', ->
      assert bot.emit.calledWithExactly 'join', 'tom95|afk'
