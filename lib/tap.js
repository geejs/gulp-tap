var DEBUG, ES, baseStream, cache, id, utils;

ES = require('event-stream');

baseStream = require('stream');

id = 1;

cache = {};

DEBUG = process.env.NODE_ENV === 'development';

utils = function(tapStream, file) {
  return {
    /*
    # Routes through another stream. The filter must not be
    # created. This will create the filter as needed and
    # cache when it can.
    #
    # @param filter {stream}
    # @param args {Array} Array containg arguments to apply to filter.
    #
    # @example
    #   t.through coffee, [{bare: true}]
    */

    through: function(filter, args) {
      var stream;
      if (filter.__tapId) {
        stream = cache[filter.__tapId];
        if (!stream) {
          cache[filter.__tapId] = null;
        }
      }
      if (!stream) {
        if (DEBUG) {
          if (!Array.isArray(args)) {
            throw new Error("Args must be an array to `apply` to the filter");
          }
        }
        stream = filter.apply(null, args);
        filter.__tapId = "" + id;
        cache[filter.__tapId] = stream;
        id += 1;
        stream.pipe(tapStream);
      }
      stream.write(file);
      return stream;
    }
  };
};

/*
# Taps into the pipeline and allows user to easily route data through
# another stream or change content.
*/


module.exports = function(lambda) {
  var modifyFile;
  modifyFile = function(file) {
    var obj;
    obj = lambda(file, utils(this, file));
    if (!(obj instanceof baseStream)) {
      return this.emit('data', file);
    }
  };
  return ES.through(modifyFile);
};
