define [
  'hbsTemplate'
  'lib/utils'
  'application'
  'views/base/collection_view'
  'views/discussion/discussion_view'
], (hbs, utils, app, CollectionView, DiscussionView) ->

  class DiscussionListView extends CollectionView
    className: "btn-group btn-group-vertical"
    itemView: DiscussionView
