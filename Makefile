default: compile

compile:
	@find src -name '*.coffee' | xargs ./node_modules/.bin/coffee -c -o build

test:
	@./node_modules/mocha/bin/mocha \
	    --compilers coffee:coffee-script/register \
	    tests/*.coffee
