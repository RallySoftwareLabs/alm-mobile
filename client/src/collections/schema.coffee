Promise = require('es6-promise').Promise
_ = require 'underscore'
appConfig = require 'app_config'
utils = require 'lib/utils'
AllowedValues = require 'collections/allowed_values'
Collection = require 'collections/collection'
Defect = require 'models/defect'
Task = require 'models/task'
TypeDefinition = require 'models/type_definition'
UserStory = require 'models/user_story'

module.exports = class Schema extends Collection
  typePath: '__schema__'
  url: appConfig.almWebServiceBaseUrl + '/schema/@@WSAPI_VERSION/project'
  model: TypeDefinition

  fetchForProject: (project) ->
    projectOid = utils.getOidFromRef project.get('_ref')
    projectSchema = project.get('SchemaVersion')
    @url = "#{appConfig.almWebServiceBaseUrl}/schema/@@WSAPI_VERSION/project/#{projectOid}/#{projectSchema}"

    @fetch(accepts: json: 'text/plain')

  ###*
   * @param {Model} model The model to get the allowed values for
   * @param {String} fieldName The field in the model to get the allowed values for
   * @returns {Promise} A promise that resolves to the array of allowed values for this model field
  ###
  getAllowedValues: (model, fieldName) ->
    attr = @getAttribute(model, fieldName)
    if attr then @_getAttributeAllowedValues(attr) else []

  hasAllowedValues: (model, fieldName) ->
    @getAttribute(model, fieldName).Constrained

  getFieldDisplayName: (model, fieldName) ->
    @getAttribute(model, fieldName).Name

  getTypeDef: (model) ->
    m = (model:: || model)
    if m.typePath
      typePath = m.typePath.toLowerCase()
    else if _.isFunction(m.get)
      typePath = m.get('_type').toLowerCase()
    typeDef = @find (type) -> type.get('TypePath').toLowerCase() == typePath

  getAttributes: (model) ->
    @getTypeDef(model).get('Attributes')

  getAttribute: (model, fieldName) ->
    attribute = _.find(@getAttributes(model), ElementName: fieldName)

  _getAttributeAllowedValues: (attr) ->
    new Promise (resolve, reject) ->
      if _.isArray attr.AllowedValues
        resolve(
          _.map(
            attr.AllowedValues,
            (value) -> _.extend(value, AllowedValueType: attr.AllowedValueType)
          )
        )
      else if attr.Constrained
        av = new AllowedValues()
        av.clientMetricsParent = this
        av.url = attr.AllowedValues._ref
        av.fetch().then ->
          resolve av.map((value) ->
            _.extend(value.toJSON(), AllowedValueType: attr.AllowedValueType)
          )
      else
        resolve []
