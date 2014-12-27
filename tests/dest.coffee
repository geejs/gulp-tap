fs    = require 'fs'
path  = require 'path'
gulp  = require 'gulp'
tap   = require '../lib/tap'

exports.tapTest =

#  setUp: (callback) ->
#    @calculator = new Calculator
#    callback()

  'gulp-tap can change dest in the middle of stream': (test) ->
    destinations =
      "scss": "sass"
      "js":   "scripts"
      "img":  "assets/images"

    # helper function to get a path relative to the root
    getPath = (rel) -> path.resolve __dirname, "..", rel

    fixturePath = getPath "tests/fixtures/"

    fs.readdir fixturePath, (err, files) ->
      test.expect 3
      if err
        test.ok no, "Can not read fixtures"
        test.done(err)

      gulp.src files.map (p) -> (fixturePath + "/" + p)
        .pipe tap where
        .on "end", ->
          test.ok !fs.existsSync getPath "sass/s.scss", "sass file"
          test.ok !fs.existsSync getPath "assets/images/img.png", "image file"
          test.ok !fs.existsSync getPath "scripts/js.js", "js file"
          test.done()
        .on "error", (err) -> test.done(err)

    where = (file, t) ->
      match = (p) ->
        ext = (path.extname p).substr 1 # remove leading "."
        if( ext in ["jpg", "png", "svg", "gif"] )
          ext = "img"
        [destinations[ext] or null]

      destPath = (match file.path)
        .filter (p) -> p isnt null

      if destPath.length
        t.through gulp.dest, destPath
