assert  = require 'assert'
events  = require 'events'
counter = require '../src/util/counter'

describe 'the prophet module', ->
  bot = new events.EventEmitter()
  require('../src/modules/prophet')(bot)

  beforeEach ->
    counter.wipe()
    counter.set 'bbart:1:1', 10
    counter.set 'total_mins:1:1', 20

  after ->
    counter.wipe()

  describe '.find_user()', ->
    it '.online_probability_on() returns the probability of a user being online at a given day and hour', ->
      assert.equal 50, bot.find_user('bbart').online_probability_on(1, 1)

    it '.online_probability() returns the probability of a user being online at every possible combination of days and hours', ->
      assert.deepEqual(
        [ [ 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
          [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
          [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
          [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
          [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
          [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
          [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ],
       bot.find_user('bbart').online_probability())

