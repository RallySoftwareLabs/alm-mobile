define [
  'views/base/view'
], (View) ->

  pageSlider = null

  class PageView extends View
    region: 'main'
    renderedSubviews: no

    initialize: (options) ->
      super
      modelOrCollection = @model or @collection
      if modelOrCollection
        rendered = options?.autoRender || @autoRender || false
        @listenTo modelOrCollection, 'change', =>
          @render() unless rendered
          rendered = true

    getNavigationData: ->
      {}

    renderSubviews: ->
      return

    render: (transition = true) ->
      super
      unless @renderedSubviews
        @renderSubviews()
        @renderedSubviews = yes
      @publishEvent 'navigation:change', @getNavigationData()
