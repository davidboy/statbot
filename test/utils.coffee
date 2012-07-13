assert = require 'assert'

# No tests for the date helpers - they are too straightforward.

describe 'the flatten util', ->
  flatten = require '../src/util/flatten'

  it 'flattens nested arrays', ->
    assert.deepEqual [1, 2, 3, 4], flatten([[1, 2], [3, 4]])

  it 'won\'t work if the array is more than two levels deep', ->
    assert.notDeepEqual [1, 2, 3, 4], flatten([[1, [2, [3, 4]]]])

describe 'the counter library', ->
  counter = require '../src/util/counter'

  before -> counter.wipe()
  after  -> counter.wipe()

  it 'automatically creates new counters when needed', ->
    counter.incr 'foobar'
    assert.equal 1, counter.get 'foobar'

  it 'can increment and decrement counters on demand', ->
    counter.incr 'barbaz'
    assert.equal 1, counter.get 'barbaz'

    counter.decr 'barbaz'
    assert.equal 0, counter.get 'barbaz'

  it 'can provide a list of all counters', ->
    assert.deepEqual ['foobar', 'barbaz'], counter.names()

  it 'can arbitrarily set a counter', ->
    counter.set 'priceofriceinchina', 3.50
    assert.equal 3.50, counter.get 'priceofriceinchina'

  it 'can reset a counter to zero', ->
    counter.reset 'priceofriceinchina'
    assert.equal 0, counter.get 'priceofriceinchina'

  it 'can totally remove all counters', ->
    assert counter.names().length > 0
    counter.wipe()
    assert.equal 0, counter.names().length

  it 'defaults to 0 when a non-existant counter is accessed', ->
    assert.equal 0, counter.get 'sdhgfuekrhdgfuershdf'
