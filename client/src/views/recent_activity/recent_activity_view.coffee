define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  PageView = require 'views/base/page_view'
  DiscussionListView = require 'views/discussion/discussion_list_view'

  class RecentActivityView extends PageView
    template: hbs['recent_activity/templates/recent_activity']
    className: "row listing"

    afterRender: ->
      @updateTitle "Recent Activity for #{app.session.getProjectName()}"
      listView = new DiscussionListView(
        container: @$el
        collection: @collection
        showItemArtifact: true
      )
      @subview 'list', listView