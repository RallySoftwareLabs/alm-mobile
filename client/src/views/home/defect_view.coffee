define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  View = require 'views/base/view'

  class DefectView extends View

    template: hbs['home/templates/defect']

    getTemplateData: ->
      # error: @options.error
      defect: @model.toJSON()
