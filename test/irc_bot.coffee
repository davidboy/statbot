assert  = require 'assert'
sinon   = require 'sinon'
mockery = require 'mockery'
events  = require 'events'

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

    require('../src/modules/irc_bot')(bot)

  after ->
    mockery.deregisterAll()
    mockery.disable()

  it 'should work', ->
    # Ensure that the irc bot is being created
    assert client_creator.calledWithNew()

    # Ensure the module is connecting to the right network
    assert client_creator.calledWith 'irc.freenode.net'

    # Now, let's fire off some events on the irc bot, and ensure the module is
    #   propagating them correctly into statbot for other modules to use.

    client.emit 'join', '#kittybot', 'davidboy', 'hai'
    assert bot.emit.calledWithExactly 'join', 'davidboy'

    client.emit 'part', '#kittybot', 'davidboy', 'imad', 'bye'
    assert bot.emit.calledWithExactly 'quit', 'davidboy'

    client.emit 'quit', 'davidboy', 'imad', '#kittybot'
    assert bot.emit.calledWithExactly 'quit', 'davidboy'

    client.emit 'names', '#kittybot', {'khampal': 'ops', 'davidboy': 'normal'}
    assert bot.emit.calledWithExactly 'join', 'khampal'
    assert bot.emit.calledWithExactly 'join', 'davidboy'

    client.emit 'nick', 'tom95', 'tom95|afk', ['#kittybot', '#elementary'], 'change!'
    assert bot.emit.calledWithExactly 'quit', 'tom95'
    assert bot.emit.calledWithExactly 'join', 'tom95|afk'


# Whew.  Let's go eat some chocolate now.
