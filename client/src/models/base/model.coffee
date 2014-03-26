_ = require 'underscore'
Backbone = require 'backbone'
Messageable = require 'lib/messageable'
SchemaMixin = require 'models/base/schema_mixin'

# Base class for all models.
module.exports = class Model extends Backbone.Model
  idAttribute: 'ObjectID'

  _.extend @prototype, Messageable
  _.extend this, SchemaMixin.static
  _.extend @prototype, SchemaMixin.prototype

  constructor: ->
    super
    @synced = false
    this.once('sync', => @synced = true)

  parse: (resp) ->
    return resp if resp._ref?
    return resp.OperationResult.Object if resp.OperationResult?
    return resp.CreateResult.Object if resp.CreateResult?
    return (value for key, value of resp)[0] # Get value for only key

  isNew: ->
    !@id? && !@_ref

  isSynced: -> @synced

  setSynced: (@synced) ->
