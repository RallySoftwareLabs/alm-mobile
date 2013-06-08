define ->
  CollectionView = require 'views/base/collection_view'
  DiscussionView = require 'views/discussion/discussion_view'

  class DiscussionListView extends CollectionView
    className: "btn-group btn-group-vertical"
    itemView: DiscussionView
