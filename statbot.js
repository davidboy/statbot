(function() {
  var app, client, express, irc, records;

  irc = require('irc');

  express = require('express');

  records = {
    '#elementary-web': {},
    '#ruby': {},
    '#kittybot': {}
  };

  client = new irc.Client('irc.freenode.net', 'statbot', {
    channels: ['#kittybot', '#ruby']
  });

  client.addListener('join', function(channel, nick, message) {
    var data;
    if (!records[channel][nick]) records[channel][nick] = [];
    data = {
      action: 'join',
      date: Date.now()
    };
    records[channel][nick].push(data);
    return console.log("" + nick + " joined " + channel);
  });

  client.addListener('part', function(channel, nick, reason, message) {
    var data;
    if (!records[channel][nick]) records[channel][nick] = [];
    data = {
      action: 'part',
      date: Date.now()
    };
    records[channel][nick].push(data);
    return console.log("" + nick + " left " + channel);
  });

  client.addListener('message', function(from, to, message) {
    if (message === '!printlogs') return console.log(JSON.stringify(records));
  });

  app = express.createServer();

  app.get('/', function(req, res) {
    return res.send('Hello world!');
  });

  app.listen(80);

  console.log('Started!');

}).call(this);
