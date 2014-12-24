gulp     = require 'gulp'
gulp-tap = require '../lib/tap'

exports.tapTest =

    'test can add two positive numbers': (test) ->
        calculator = new Calculator
        result = calculator.add 2, 3
        test.equal(result, 5)
        test.done()
