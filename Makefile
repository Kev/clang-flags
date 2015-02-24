.PHONY : build

build: node_modules/coffee-script
	./node_modules/coffee-script/bin/coffee -o lib/ -c lib/

node_modules/coffee-script:
	npm install
