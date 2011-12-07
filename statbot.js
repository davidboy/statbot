(function() {
  var app, express, records;

  express = require('express');

  records = {
    '#elementary-web': {},
    '#ruby': {},
    '#kittybot': {}
  };

  app = express.createServer();

  app.get('/', function(req, res) {
    return res.send('Hello world!');
  });

  app.listen(process.env.PORT, function() {
    return console.log('Started web server!');
  });

}).call(this);
