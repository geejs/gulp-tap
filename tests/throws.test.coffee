process.env['NODE_ENV'] = 'development'

fs    = require 'fs'
path  = require 'path'
gulp  = require 'gulp'
tap   = require '../'
tapTest = require 'tap'


# helper function to get a path relative to the root
getPath = (rel) -> path.resolve __dirname, '..', rel


tapTest.test "throw error if array is not passed as argument to .through", (test) ->

	test.plan 1

	gulp.src getPath 'tests/fixtures/' + 'js.js'
	.pipe tap (file, t) ->
		test.throws t.through, new Error("Args must be an array to `apply` to the filter")
