define [
  'hbsTemplate'
  'views/base/view'
], (hbs, View) ->

  class DiscussionView extends View

    template: hbs['discussion/templates/discussion']

    getTemplateData: ->
      # error: @options.error
      discussion: @model.toJSON()
