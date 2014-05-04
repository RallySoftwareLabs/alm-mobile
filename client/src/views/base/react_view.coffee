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
    @_subscribe(@getModel())

    @__initLoadingIndicator__() if @props.showLoadingIndicator == true

  componentWillReceiveProps: (nextProps) ->
    model = @getModel()
    nextModel = @getModel(nextProps)
    if model != nextModel
      @_unsubscribe(model)
      @_subscribe(nextModel)

  componentWillUnmount: ->
    # Ensure that we clean up any dangling references when the component is destroyed.
    @_unsubscribe(@getModel())
    @unsubscribeAllEvents()

module.exports = {
  createBackboneClass: (spec) ->
    currentMixins = spec.mixins || []

    spec.mixins = currentMixins.concat [React.BackboneMixin, Messageable]

    spec.getModel = (props = @props) -> props.model || props.collection || props.store

    spec.model = -> @getModel()

    spec.el = -> @isMounted() && @getDOMNode()

    spec.$ = (selector) -> $(@getDOMNode()).find selector

    spec.$el = $(@el)

    spec.updateTitle = (title) ->
      @publishEvent "updatetitle", title

    spec.routeTo = (route) ->
      @publishEvent 'router:route', route

    spec.handleEnterAsClick = (fn) ->
      (e) => if e.key == "Enter" then fn.call(this, e)

    React.createClass(spec)
}