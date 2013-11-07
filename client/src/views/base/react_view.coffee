define ->
  $ = require 'jquery'
  _ = require 'underscore'
  React = require 'react'
  Chaplin = require 'chaplin'
  Spinner = require 'spin'
  Collection = require 'collections/collection'

  React.BackboneMixin =
    _subscribe: (model) ->
      return unless model?
      # Detect if it's a collection
      if model instanceof Collection
        model.on('add remove reset sort', ->
          @forceUpdate()
        , this)
      else if model
        changeOptions = @changeOptions || 'change'
        model.on(changeOptions, ->
          model
          (@onModelChange || @forceUpdate).call(this)
        , this)

    _unsubscribe: (model) ->
      return unless model?
      model.off(null, null, this)

    __initLoadingIndicator__: ->
      model = @getModel()
      return unless model

      syncEvent = if _.isFunction(model.isSyncing) then 'syncStateChange' else 'sync'
      @listenTo model, syncEvent, _.bind(@__toggleLoadingIndicator__, this, false)
      @__toggleLoadingIndicator__ true

    __toggleLoadingIndicator__: (show = false) ->
      model = @getModel()

      visible = if _.isFunction(model.isSyncing) then model.isSyncing() else show

      if visible
        $(@getDOMNode()).append(new Spinner().spin().el)
      else
        $(@getDOMNode()).find('.spinner').remove()

    componentDidMount: ->
      # Whenever there may be a change in the Backbone data, trigger a reconcile.
      @_subscribe(@props.model)

      @__initLoadingIndicator__() if @props.showLoadingIndicator == true

    componentWillReceiveProps: (nextProps) ->
      if @props.model != nextProps.model
        @_unsubscribe(@props.model)
        @_subscribe(nextProps.model)

    componentWillUnmount: ->
      # Ensure that we clean up any dangling references when the component is destroyed.
      @_unsubscribe(@props.model)

    dispose: ->
      return unless @isMounted()
      dn = @getDOMNode()
      parent = dn.parentElement
      @unmountComponent()
      parent.removeChild dn

  return {
    createChaplinClass: (spec) ->
      currentMixins = spec.mixins || []

      spec.mixins = currentMixins.concat [React.BackboneMixin, Backbone.Events, Chaplin.EventBroker]

      spec.getModel = -> @props.model || @props.collection

      spec.model = -> @getModel()

      spec.el = -> @isMounted() && @getDOMNode()

      spec.updateTitle = (title) ->
        @publishEvent "updatetitle", title

      # listens to an event on the object and refires is as its own
      spec.bubbleEvent = (obj, event, mappedAs = event) ->
        @listenTo obj, event, (args...) => @trigger.apply this, [mappedAs].concat(args) 

      React.createClass(spec)
  }