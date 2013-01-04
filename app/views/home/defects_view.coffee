View = require '../view'
template = require './templates/defects'
app = require 'application'

module.exports = View.extend

  el: '#defect-view'
  template: template
  events:
    'click #add-defect' : 'addDefect'

  getRenderData: ->
    # error: @options.error
    defects: @model.toJSON()

  addDefect: ->
    app.router.navigate 'new/defect', {trigger: true, replace: true}