ES = require('event-stream')
baseStream = require('stream')

id = 1
cache = {}
DEBUG = process.env.NODE_ENV is 'development'

utils = (tapStream, file) ->

  ###
  # Routes through another stream. The filter must not be
  # created. This will create the filter as needed and
  # cache when it can.
  #
  # @param filter {stream}
  # @param args {Array} Array containg arguments to apply to filter.
  #
  # @example
  #   t.through coffee, [{bare: true}]
  ###
  through: (filter, args) ->
    if filter.__tapId
      stream = cache[filter.__tapId]
      cache[filter.__tapId] = null unless stream

    unless stream
      if DEBUG
        if !Array.isArray(args)
          throw new Error("Args must be an array to `apply` to the filter")
      stream = filter.apply(null, args)
      filter.__tapId = ""+id
      cache[filter.__tapId] = stream
      id += 1
      stream.pipe tapStream
    stream.write file
    stream


###
# Taps into the pipeline and allows user to easily route data through
# another stream or change content.
###
module.exports = (lambda) ->
  modifyFile = (file) ->
    obj = lambda(file, utils(this, file))

    # passthrough if user returned a stream
    this.emit('data', file) unless obj instanceof baseStream

  return ES.through(modifyFile)

