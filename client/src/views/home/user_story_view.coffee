define [
  'hbsTemplate'
  'application'
  'views/base/view'
], (hbs, app, View) ->

  class UserStoryView extends View

    template: hbs['home/templates/user_story']

    getTemplateData: ->
      # error: @options.error
      story: @model.toJSON()
