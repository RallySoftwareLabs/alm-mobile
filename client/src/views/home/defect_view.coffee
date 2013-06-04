define [
  'hbsTemplate'
  'application'
  'views/base/view'
], (hbs, app, View) ->

  class DefectView extends View

    template: hbs['home/templates/defect']

    getTemplateData: ->
      # error: @options.error
      defect: @model.toJSON()
