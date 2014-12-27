# gulp-tap

Easily tap into a pipeline.

## Uses

Some filters like `gulp-coffee` process all files. What if you want to process
all JS and Coffee files in a single pipeline. Use `tap` to filter out `.coffee`
files and process them through the `coffee` filter and let JavaScript files
pass through.

```js
gulp.src("src/**/*.{coffee,js}")
    .pipe(tap(function(file, t) {
        if (path.extname(file.path) === '.coffee') {
            return t.through(coffee, []);
        }
    }))
    .pipe(gulp.dest('build'));
```

Save files to different locations based on file extension.
```js
var destinations = {
  "scss": "sass",
  "js": "scripts",
  "img": "assets/images"
};

var files = ["loongpath/s.scss", "another/js.js", "verylongpath/img.png"];

gulp.src(files).pipe(tap(where));

function where(file, t) {
  var destPath, match;
  match = function(p) {
    var ext;
    ext = path.extname(p)
      .substr(1); // remove leading "."
    if ((ext === "jpg" || ext === "png" || ext === "svg" || ext === "gif")) {
      ext = "img";
    }
    return destinations[ext] || false;
  };
  destPath = match(file.path);
  if (destPath) {
    return t.through(gulp.dest, [destPath]);
  }
};
```

What if you want to change content like add a header? No need for a separate
filter, just change the content.

```js
tap(function(file) {
    file.contents = Buffer.concat([
        new Buffer('HEADER'),
        file.contents
    ]);
});
```

If you do not return a stream, tap forwards your changes.


## License

The MIT License (MIT)
