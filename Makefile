test:
	mocha --compilers coffee:coffee-script --reporter min --watch

spec:
	mocha --compilers coffee:coffee-script --reporter spec

run:
	node_modules/coffee-script/bin/coffee src/statbot.coffee

.PHONY: test spec run
