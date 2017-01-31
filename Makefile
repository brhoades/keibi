default: client

client:
	@find src/client -name '*.coffee' | xargs ./node_modules/.bin/coffee -c -o build/client

server:
	@find src/server -name '*.coffee' | xargs ./node_modules/.bin/coffee -c -o build/server

test:
	@./node_modules/mocha/bin/mocha \
	    --compilers coffee:coffee-script/register \
	    tests/*.coffee

clean:
	@rm -rf build/*
