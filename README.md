# About Me
**statbot** is a simple irc bot which tracks all the joins and parts of users in an irc channel.  From that data, charts can be generated which show the best day and hour to catch someone online.

# Statbot Internals
## Events
The statbot core is nothing more than an instance of `EventEmitter`.  It periodically (at the request of various modules) emits one of three unique events, which the various modules subscribe to.

* `join` is emitted whenever a new user comes online.  It has one paramater, the username of the newly joined user.
*  `quit` is emitted when a user leaves the channel.  Like `join`, it has one username parameter.
* The `tick` event is statbot's heartbeat.  It's emitted every 1 minute, and has no paramaters.


## Modules
The actual bot logic is organized into a bunch of modules, found in `src/modules/`  Each module has a single defined purpose.  That way, the code is nice and clean, plus it's easier to test.  Desired modules (listed in `src/statbot.coffee`) are each loaded in order, and the function it exports is called, with the bot object and any config settings for that module as an argument.  (Yes, this is _very_ similar to the scheme used by [hubot](https://github.com/github/hubot)).

### Server adapters (choose one)
These modules connect to a chat server, and tell statbot to emit the `join` and `quit` events whenever the corresponding action happens in a chatroom.
* `irc_bot` constructs an irc bot (using [node-irc](https://github.com/martynsmith/node-irc)) which sits on an irc server in a list of specified channels.
* `rabbitbot` hooks into elementary's RabbitBot.  Coming soon!

### Required modules
* `ticker`: this module causes statbot to emit the `tick` event as described above.
* `scribe` maintains counters which track how many seconds every user has been online on every hour of every day.
* `users` maintains a list of all the users statbot has seen, along with their status (online or offline).
* `prophet` makes predictions about the probability of a user being online at a given day and hour, using the data gathered by `ticker`.
* `api` runs a web server to generate online probability graphs using `prophet`'s predictions.

### Extra modules (optional)
* `logger` just logs user activity to the console.  Useful during debuging.
* `persistence` writes all counters to disk on every tick, and also restores the last counter dump at bot startup.  Enable this if there's any chance whatsoever of the bot crashing.  For best results, load after `scribe`.
* `shnatsel` implements logging all actions to datafiles in the format supported by [shnatsel's presence-log-parser](https://code.launchpad.net/~shnatsel/elementaryweb/presence-log-parser).  Coming soon!
