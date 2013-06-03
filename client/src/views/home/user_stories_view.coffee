define [
  'hbsTemplate'
  'application'
  'views/view'
], (hbs, app, View) ->

  View.extend

    el: '#userstory-view'
    template: hbs['home/templates/user_stories']

    getRenderData: ->
      # error: @options.error
      stories: @model.toJSON()

    addUserStory: ->
      app.router.navigate 'new/userstory', {trigger: true, replace: true}