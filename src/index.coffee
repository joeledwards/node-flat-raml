FS = require 'fs'

Q = require 'q'
parser = require 'raml-parser'
objToRaml = require 'raml-object-to-raml'

openWriteStream = (outFile) ->
  deferred = Q.defer()
  try
    deferred.resolve FS.createWriteStream(outFile)
  catch error
    deferred.reject error
  return deferred.promise

parseRaml = (inFile) ->
  deferred = Q.defer()
  try
    parser.loadFile inFile  
      .then ((data) -> deferred.resolve(data)), ((error) -> deferred.reject(error))
  catch error
    deferred.reject error
  return deferred.promise

serializeRaml = (ramlObj) ->
  deferred = Q.defer()
  try
    deferred.resolve objToRaml(ramlObj)
  catch error
    deferred.reject error
  return deferred.promise
  
writeRaml = (serialized, outFile) ->
  deferred = Q.defer()
  try
    FS.writeFile outFile, serialized 
    deferred.resolve {} 
  catch error
    deferred.reject(error)
  return deferred.promise

ramlAsString = (inFile) ->
  parseRaml inFile 
  .then (data) -> serializeRaml(data)

flattenRamlDoc = (inFile, outFile) ->
  ramlAsString inFile
  .then (serialized) -> writeRaml(serialized, outFile)
  .then () -> outFile
  
module.exports = {
  flatten : flattenRamlDoc,
  asString : ramlAsString
}

