define [
  'backbone'
  'hbsTemplate'
  'spin'
], (Backbone, hbs, Spinner) ->
  Backbone.View.extend

    template: hbs['shared/templates/loading']

    getRenderData: (el) ->
      opts = {top: 1, left: 1}
      spinner: new Spinner(opts).spin().el

    render: ->
      @$el.append(new Spinner().spin().el)