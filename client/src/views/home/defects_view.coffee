define [
  'application'
  'views/view'
], (app, View) ->

  View.extend

    el: '#defect-view'
    template: JST['home/templates/defects']
    events:
      'click #add-defect' : 'addDefect'

    getRenderData: ->
      # error: @options.error
      defects: @model.toJSON()

    addDefect: ->
      app.router.navigate 'new/defect', {trigger: true, replace: true}