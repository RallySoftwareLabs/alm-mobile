define ->
  hbs = require 'hbsTemplate'
  View = require 'views/base/view'

  class DiscussionView extends View

    template: hbs['discussion/templates/discussion']

    initialize: (options = {}) ->
    	@showItemArtifact = options.showItemArtifact
    	super

    getTemplateData: ->
    	data = super
    	data.showItemArtifact = @showItemArtifact
    	data
