coffee = require("gulp-coffee")
{dest} = require("gulp")

exports.project = ->
  scripts:
    files: "src/**/*.coffee"
    pipeline: -> [
      coffee bare: true
      dest("lib")
    ]

