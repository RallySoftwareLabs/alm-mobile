define ->
  $ = require 'jquery'
  _ = require 'underscore'

  return {
    prototype:
      getAllowedValues: (field) ->
        @allowedValues[field]
      
    static:
      getAllowedValues: (field) ->
        @prototype.allowedValues[field]

      getFieldDisplayName: (fieldElementName) ->
        @prototype.fields[fieldElementName]?.Name

  }