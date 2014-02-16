define ->
  app = require 'application'
  Discussions = require 'collections/discussions'
  SiteController = require 'controllers/base/site_controller'
  DiscussionView = require 'views/discussion/discussion'

  class RecentActivityController extends SiteController

    show: (params) ->
      @whenLoggedIn ->
        discussions = new Discussions()
        discussions.fetch(
          data:
            fetch: "Text,User,Artifact,CreationDate,FormattedID"
            project: app.session.get('project').get('_ref')
            projectScopeUp: false
            projectScopeDown: true
            order: "CreationDate DESC,ObjectID"
        ).always => @markFinished()
        
        @view = @renderReactComponent(DiscussionView,
          region: 'main'
          model: discussions
          showInput: false
          showItemArtifact: true
        )
        @updateTitle "Recent Activity for #{app.session.getProjectName()}"
