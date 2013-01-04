View = require '../view'
template = require './templates/defects'
LoadingMaskView = require '../shared/loading_view'
app = require 'application'

module.exports = View.extend

  el: '#defect-view'
  template: template
  events:
    'click #add-defect' : 'addDefect'

  renderLoadingMask: ->
    mask = new LoadingMaskView()
    mask.setElement(@el)
    mask.render()

  getRenderData: ->
    # error: @options.error
    defects: @model.toJSON()

  addDefect: ->
    app.router.navigate 'new/defect', {trigger: true, replace: true}