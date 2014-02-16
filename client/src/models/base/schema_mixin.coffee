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
          @prototype.fields = {}
          attributes = model.get('Attributes')

          _.each attributes, (attr) => @prototype.fields[attr.ElementName] = {Name: attr.Name}
          
          allowedValues = _.map(
            _.filter(attributes, (attr) => attr.ElementName in @prototype.allowedValueFields),
            _.partial(@_getAttributeAllowedValues, schema)
          )

        $.when.apply($, allowedValues).then (values...) =>
          @prototype.allowedValues = _.object values

      getFieldDisplayName: (fieldElementName) ->
        @prototype.fields[fieldElementName]?.Name

      _getAttributeAllowedValues: (schema, attr) ->
        return if _.isArray attr.AllowedValues
          [attr.ElementName, attr.AllowedValues]
        else
          av = new AllowedValues()
          av.clientMetricsParent = schema
          av.url = attr.AllowedValues._ref
          av.fetch().then -> [attr.ElementName, av.invoke('toJSON')]

  }