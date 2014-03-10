define ->
  $ = require 'jquery'
  _ = require 'underscore'
  React = require 'react'
  Messageable = require 'lib/messageable'
  Spinner = require 'spin'
  Collection = require 'collections/collection'

  React.BackboneMixin =
    _getModelEvents: (model) ->
      if model instanceof Collection
        @props.changeOptions || 'add remove reset sort'
      else if model
        @props.changeOptions || 'sync change'

    _subscribe: (model) ->
      return unless model?
      model.on(@_getModelEvents(model), ->
        (@onModelChange || @forceUpdate).call(this)
      , this)

    _unsubscribe: (model) ->
      return unless model?
      model.off(null, null, this)

    __initLoadingIndicator__: ->
      model = @getModel()
      return unless model

      model.once @_getModelEvents(model), _.bind(@__toggleLoadingIndicator__, this, false)
      @__toggleLoadingIndicator__ true

    __toggleLoadingIndicator__: (show = false) ->
      model = @getModel()

      if show
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
      @unsubscribeAllEvents()

  return {
    createBackboneClass: (spec) ->
      currentMixins = spec.mixins || []

      spec.mixins = currentMixins.concat [React.BackboneMixin, Messageable]

      spec.getModel = -> @props.model || @props.collection

      spec.model = -> @getModel()

      spec.el = -> @isMounted() && @getDOMNode()

      spec.$ = (selector) -> $(@getDOMNode()).find selector

      spec.$el = $(@el)

      spec.renderForBackbone = (id) ->
        React.renderComponent this, (if id then document.getElementById(id) else document.body)

      spec.updateTitle = (title) ->
        @publishEvent "updatetitle", title

      spec.routeTo = (route) ->
        @publishEvent 'router:route', route

      spec.keyCodes =
        ENTER_KEY: 13
        ESCAPE_KEY: 27

      React.createClass(spec)
  }