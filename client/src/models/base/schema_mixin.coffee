define ->
  $ = require 'jquery'
  _ = require 'underscore'

  return {
    prototype:
      getAllowedValues: (field) ->
        app = require 'application'
        schema = app.session.get('schema')
        schema.getAllowedValues(this, field)

      hasAllowedValues: (field) ->
        app = require 'application'
        schema = app.session.get('schema')
        schema.hasAllowedValues(this, field)
      
    static:
      getAllowedValues: (field) ->
        @prototype.getAllowedValues(field)

      hasAllowedValues: (field) ->
        @prototype.hasAllowedValues(field)

      getFieldDisplayName: (fieldName) ->
        app = require 'application'
        schema = app.session.get('schema')
        schema.getFieldDisplayName(this, fieldName)

  }