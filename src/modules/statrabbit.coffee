# This is the function that's called by rabbit bot when it loads this module.
module.exports.init = (client) ->

  # Overwrite module.exports and change it to a new function.  This'll now be
  #   called when statbot loads this module.
  module.exports = (bot) ->
    # So, statbot has loaded us.  Let's load statbot's irc_bot module, but make
    #   it use the irc client that rabbitbot gave us earlier.
    require('./irc_bot')(bot, {}, client)

  # Alright, rabbitbot has loaded this module, we've overwritten module.exports
  #   so statbot will know what to do.  Next step: run statbot!
  require '../statbot'
