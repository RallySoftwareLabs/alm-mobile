define ->
  $ = require 'jquery'
  _ = require 'underscore'
  AllowedValues = require 'collections/allowed_values'

  return {
    prototype:
      getAllowedValues: (field) ->
        @allowedValues[field]
      
    static:
      getAllowedValues: (field) ->
        @prototype.allowedValues[field]

      updateFromSchema: (schema) ->
        model = schema.find (model) => model.get('TypePath').toLowerCase() == @prototype.typePath

        allowedValues = []

        if model
          allowedValues = _.map(
            _.filter(model.get('Attributes'), (attr) => attr.ElementName in @prototype.allowedValueFields),
            @_getAttributeAllowedValues
          )

        $.when.apply($, allowedValues).then (values...) =>
          @prototype.allowedValues = _.object values

      _getAttributeAllowedValues: (attr) ->
        return if _.isArray attr.AllowedValues
          [attr.ElementName, attr.AllowedValues]
        else
          av = new AllowedValues
          av.url = attr.AllowedValues._ref
          av.fetch().then -> [attr.ElementName, av.serialize()]

  }