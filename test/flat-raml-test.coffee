Q = require 'q'
FS = require 'fs'
assert = require 'assert'

flattener = require '../src/index'

describe "flattener", ->
  it "should flatten the source document into a single file", (done) ->
    testFile = 'test/test.raml'
    allFile = 'test/all.raml'
    try
      if FS.existsSync allFile
        FS.unlinkSync allFile

      flattener.flatten testFile, allFile
      .then (outFile) -> Q.all([flattener.asString(testFile), flattener.asString(outFile)])
      .then (strings) -> assert.equal strings[0], strings[1]
      .catch (error) -> 
        console.log("error:", error, "\nstack:\n", error.stack)
        done error
      .fin -> done()
    catch error
      done error
