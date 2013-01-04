template = require './templates/loading'

module.exports = Backbone.View.extend

  template: template

  getRenderData: (el) ->
    opts = {top: 1, left: 1}
    spinner: new Spinner(opts).spin().el

  render: ->
    @$el.append(new Spinner().spin().el)