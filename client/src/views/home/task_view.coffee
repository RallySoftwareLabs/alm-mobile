define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  View = require 'views/base/view'

  class TaskView extends View

    template: hbs['home/templates/task']

    getTemplateData: ->
      # error: @options.error
      task: @model.toJSON()
