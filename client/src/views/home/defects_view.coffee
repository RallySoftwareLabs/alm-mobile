define [
  'hbsTemplate'
  'application'
  'views/view'
], (hbs, app, View) ->

  View.extend

    el: '#defect-view'
    template: hbs['home/templates/defects']
    events:
      'click #add-defect' : 'addDefect'

    getRenderData: ->
      # error: @options.error
      defects: @model.toJSON()

    addDefect: ->
      app.router.navigate 'new/defect', {trigger: true, replace: true}