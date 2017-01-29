default: compile

compile: 
	@find src -name '*.coffee' | xargs ./node_modules/.bin/coffee -c -o build
