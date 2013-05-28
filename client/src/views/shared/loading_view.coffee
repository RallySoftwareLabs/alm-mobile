define [
  'spin'
], (Spinner) ->
  Backbone.View.extend

    template: JST['shared/templates/loading']

    getRenderData: (el) ->
      opts = {top: 1, left: 1}
      spinner: new Spinner(opts).spin().el

    render: ->
      @$el.append(new Spinner().spin().el)