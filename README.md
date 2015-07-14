# node-flat-raml
Flatten a multi-file RAML document into a single RAML file

### Flattening a RAML document into a single file
```coffeescript
srcFile = 'spec.raml'
dstFile = 'flat.raml'
flattener = require 'flat-raml' 
flattener.flatten srcFile dstFile
  .then (outFile) -> console.log(outFile, "written")
  .catch (error) -> "error flattening RAML doc:", error, "\nstack:\n", error.stack
```

### Parsing a RAML document into a serialized string
```coffeescript
srcFile = 'spec.raml'
flattener = require 'flat-raml' 
flattener.asString srcFile
  .then (serialized) -> console.log(srcFile, "read. Serialized content:\n", serialized)
  .catch (error) -> "error reading RAML doc:", error, "\nstack:\n", error.stack
```

