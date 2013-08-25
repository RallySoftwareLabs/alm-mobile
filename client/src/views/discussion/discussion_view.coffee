define ->
  hbs = require 'hbsTemplate'
  View = require 'views/base/view'

  class DiscussionView extends View

    template: hbs['discussion/templates/discussion']
    className: 'list-group-item'
    tagName: 'li'

    initialize: (options = {}) ->
    	@showItemArtifact = options.showItemArtifact
    	super

    getTemplateData: ->
    	data = super
    	data.showItemArtifact = @showItemArtifact
    	data
