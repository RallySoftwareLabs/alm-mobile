define ->
  CollectionView = require 'views/base/collection_view'
  DiscussionView = require 'views/discussion/discussion_view'

  class DiscussionListView extends CollectionView
    className: "list-group"
    tagName: 'ul'
    itemView: DiscussionView
    loadingIndicator: true

    initialize: (options = {}) ->
    	@showItemArtifact = options.showItemArtifact
    	super

    initItemView: (model) ->
    	view = super
    	view.showItemArtifact = @showItemArtifact
    	view