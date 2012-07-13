assert  = require 'assert'
events  = require 'events'

refute = (condition) -> not condition

describe 'the users module', ->
  bot = new events.EventEmitter()
  require('../src/modules/users')(bot)

  describe 'when a user comes online', ->
    before -> bot.emit 'join', 'davidboy'

    it 'adds them to the list of known users', ->
      assert 'davidboy' in bot.all_users()

    it 'also marks them as online', ->
      assert 'davidboy' in bot.online_users()

  describe 'when a user goes offline', ->
    before -> bot.emit 'quit', 'davidboy'

    it 'keeps them in the known users list', ->
      assert 'davidboy' in bot.all_users()

    it 'removes them from the online users list', ->
      refute 'davidboy' in bot.online_users()
