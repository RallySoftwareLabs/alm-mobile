define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  View = require 'views/base/view'

  class UserStoryView extends View

    template: hbs['home/templates/user_story']

    getTemplateData: ->
      # error: @options.error
      story: @model.toJSON()
