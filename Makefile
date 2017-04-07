.PHONY: compile

compile:
	@npm run coffee -- -cbm -o lib src
