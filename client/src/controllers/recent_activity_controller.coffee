define ->
  app = require 'application'
  Discussions = require 'collections/discussions'
  SiteController = require 'controllers/base/site_controller'
  RecentActivityView = require 'views/recent_activity/recent_activity_view'

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
        @view = new RecentActivityView autoRender: true, region: 'main', collection: discussions