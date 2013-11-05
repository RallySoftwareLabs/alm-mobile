define ->
  React = require 'react'
  app = require 'application'
  Discussions = require 'collections/discussions'
  SiteController = require 'controllers/base/site_controller'
  DiscussionPageView = require 'views/discussion/discussion_page'

  class RecentActivityController extends SiteController

    show: (params) ->
      @whenLoggedIn ->
        discussions = new Discussions()
        discussions.fetch
          data:
            fetch: "Text,User,Artifact,CreationDate,FormattedID"
            project: app.session.get('project').get('_ref')
            projectScopeUp: false
            projectScopeDown: true
            order: "CreationDate DESC,ObjectID"
        @view = React.renderComponent(DiscussionPageView(model: discussions, showInput: false, showItemArtifact: true), document.getElementById('content'))
        @updateTitle "Recent Activity for #{app.session.getProjectName()}"
