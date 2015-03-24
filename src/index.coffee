FS = require 'fs'

_ = require 'lodash'
Q = require 'q'
parser = require 'raml-parser'
program = require 'commander'

parse = (inFile) ->
  console.log "parsing..."
  deferred = Q.defer()
  try
    parser.loadFile inFile  
      .then ((data) -> deferred.resolve(data)), ((error) -> deferred.reject(error))
  catch error
    console.log error
    deferred.reject(error)
  return deferred.promise

openWriteStream = (outFile) ->
  console.log "open stream..."
  deferred = Q.defer()
  try
    deferred.resolve(FS.createWriteStream(outFile))
  catch error
    console.log error
    deferred.reject(error)
  return deferred.promise

writeRaml = (data, outFile) ->
  console.log "writing raml..."
  return openWriteStream(outFile)
    .then((stream) -> streamRaml(data, stream))

streamRaml = (data, stream, depth=0) ->
  console.log "stream raml..."
  #console.log(data)
  _.forOwn(data, (value, key) -> 
    stream.write(key + ":")
    if typeof value == "object"
      stream.write("\n")
      streamRaml(value, stream, depth+1)
    else
      stream.write(" " + value)
      stream.write("\n")
  )

flattenRamlDoc = (inFile, outFile) ->
  parse inFile 
  .then (data) -> writeRaml(data, outFile)
  .then (result) -> console.log("Done.") 
  .catch (error) -> console.log("Error:", error, "\n", error.stack)
  
module.exports = {
  flatten : flattenRamlDoc
}

flattenRamlDoc "test.raml", "all.raml"
console.log "started..."
