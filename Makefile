.PHONY : build

build: node_modules/coffee-script
	./node_modules/coffee-script/bin/coffee -o lib/ -c src/

node_modules/coffee-script:
	npm install
