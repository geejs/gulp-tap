fs    = require 'fs'
path  = require 'path'
gulp  = require 'gulp'
tap   = require '../'
tapTest = require 'tap'

test2 = (file, a, b, test) ->
  test.ok true

test3 = (file, a, b, test, value) ->
  if value == "my value"
    test.ok true
    test.end()
  else 
    test.ok false
    test.end()

# helper function to get a path relative to the root
getPath = (rel) -> path.resolve __dirname, '..', rel

tapTest.test "works with passing 0, 1, n args to tap", (test) ->

    test.plan 3

    fixturePath = getPath 'tests/fixtures/'

    gulp.src fixturePath + '/js.js'
      .pipe tap (file) ->
        test.ok true

    gulp.src fixturePath + '/js.js'
      .pipe tap test2, test

    gulp.src fixturePath + '/js.js'
      .pipe tap test3, test, "my value"

