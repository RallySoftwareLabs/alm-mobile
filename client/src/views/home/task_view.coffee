define [
  'hbsTemplate'
  'application'
  'views/base/view'
], (hbs, app, View) ->

  class TaskView extends View

    template: hbs['home/templates/task']

    getTemplateData: ->
      # error: @options.error
      task: @model.toJSON()
