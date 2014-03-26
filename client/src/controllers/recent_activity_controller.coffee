app = require 'application'
Discussions = require 'collections/discussions'
SiteController = require 'controllers/base/site_controller'
DiscussionView = require 'views/discussion/discussion'

module.exports = class RecentActivityController extends SiteController

  show: (params) ->
    @whenProjectIsLoaded ->
      discussions = new Discussions()
      discussions.fetch(
        data:
          shallowFetch: "Text,User,Artifact[FormattedID],CreationDate,FormattedID"
          project: app.session.get('project').get('_ref')
          projectScopeUp: false
          projectScopeDown: true
          order: "CreationDate DESC"
      ).always => @markFinished()
      
      @view = @renderReactComponent(DiscussionView,
        region: 'main'
        model: discussions
        showInput: false
        showItemArtifact: true
      )
      @updateTitle "Recent Activity for #{app.session.getProjectName()}"
