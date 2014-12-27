fs    = require 'fs'
path  = require 'path'
gulp  = require 'gulp'
tap   = require '../src/tap'

deleteDirectory = (p) ->
  if fs.existsSync p
    fs.readdirSync(p).forEach (file) ->
      curP = (p + "/" + file)
      if fs.lstatSync(curP).isDirectory()
        deleteDirectory curP
      else
        fs.unlinkSync curP
    fs.rmdirSync p

clean = (callback) ->
  deleteDirectory "assets"
  deleteDirectory "scripts"
  deleteDirectory "sass"
  callback()


exports.tapTest =

  setUp: clean
  tearDown: clean

  'gulp-tap can change dest in the middle of stream': (test) ->
    test.expect 3

    destinations =
      "scss": "sass"
      "js":   "scripts"
      "img":  "assets/images"

    # helper function to get a path relative to the root
    getPath = (rel) -> path.resolve __dirname, "..", rel

    fixturePath = getPath "tests/fixtures/"

    fs.readdir fixturePath, (err, files) ->
      if err
        console.trace("Can not read fixtures from " + fixturePath)
        test.done()

      gulp.src files.map (p) -> (fixturePath + "/" + p)
        .pipe tap where
        .on "end", -> setTimeout ->
          test.ok fs.existsSync getPath "assets/images/img.png"
          test.ok fs.existsSync getPath "scripts/js.js"
          test.ok fs.existsSync getPath "sass/s.scss"
          test.done()
        , 500 # give gulp.dest a (500ms) chance to write the files
        .on "error", (err) ->
          console.trace(err)
          test.done()

    where = (file, t) ->
      match = (p) ->
        ext = (path.extname p)
          .substr 1 # remove leading "."
        if( ext in ["jpg", "png", "svg", "gif"] )
          ext = "img"
        destinations[ext] or false

      # for debugging
      # console.log "destPath", destPath, file.path
      destPath = match file.path

      if destPath
        t.through gulp.dest, [destPath]
