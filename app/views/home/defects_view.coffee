View = require '../view'
template = require './templates/defects'

module.exports = View.extend

  id: 'defects-view'
  template: template
  getRenderData: ->
    # error: @options.error
    defects: @model.toJSON()