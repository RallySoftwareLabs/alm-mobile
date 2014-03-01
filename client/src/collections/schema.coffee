define ->
  $ = require 'jquery'
  _ = require 'underscore'
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  AllowedValues = require 'collections/allowed_values'
  Collection = require 'collections/collection'
  Defect = require 'models/defect'
  Initiative = require 'models/initiative'
  Task = require 'models/task'
  TypeDefinition = require 'models/type_definition'
  UserStory = require 'models/user_story'

  class Schema extends Collection
    typePath: '__schema__'
    url: appConfig.almWebServiceBaseUrl + '/schema/@@WSAPI_VERSION/project'
    model: TypeDefinition

    fetchForProject: (project) ->
      projectOid = utils.getOidFromRef project.get('_ref')
      projectSchema = project.get('SchemaVersion')
      @url = "#{appConfig.almWebServiceBaseUrl}/schema/@@WSAPI_VERSION/project/#{projectOid}/#{projectSchema}"

      @fetch(accepts: json: 'text/plain')

    getAllowedValues: (model, fieldName) ->
      attr = @getAttribute(model, fieldName)
      if attr then @_getAttributeAllowedValues(attr) else []

    hasAllowedValues: (model, fieldName) ->
      @getAttribute(model, fieldName).Constrained

    getFieldDisplayName: (model, fieldName) ->
      @getAttribute(model, fieldName).Name

    getTypeDef: (model) ->
      typeDef = @find (type) -> type.get('TypePath').toLowerCase() == model.typePath

    getAttributes: (model) ->
      @getTypeDef(model).get('Attributes')
      
    getAttribute: (model, fieldName) ->
      attribute = _.find(@getAttributes(model), ElementName: fieldName)

    _getAttributeAllowedValues: (attr) ->
      allowedValues = if _.isArray attr.AllowedValues
        _.map(attr.AllowedValues, (value) -> _.extend(value, AllowedValueType: attr.AllowedValueType))
      else if attr.Constrained
        av = new AllowedValues()
        av.clientMetricsParent = this
        av.url = attr.AllowedValues._ref
        av.fetch().then -> av.map((value) -> _.extend(value.toJSON(), AllowedValueType: attr.AllowedValueType))
      else []
