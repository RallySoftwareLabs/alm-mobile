define ->
  app = require 'application'
  utils = require 'lib/utils'
  Discussion = require 'models/discussion'
  Discussions = require 'collections/discussions'
  SiteController = require 'controllers/base/site_controller'
  DiscussionPageView = require 'views/discussion/discussion_page_view'

  class DiscussionController extends SiteController
    show: (params) ->
      @whenLoggedIn ->
        @discussions = new Discussions()

        @artifactRef = utils.getRef(params.type, params.id)

        @view = new DiscussionPageView
          region: 'main'
          autoRender: true
          collection: @discussions

        @listenTo @view, 'reply', @onReplyClick

        @discussions.fetch
          data:
            fetch: "Text,User,Artifact,CreationDate"
            query: "(Artifact = #{@artifactRef})"
            order: "CreationDate DESC,ObjectID"

    onReplyClick: (text) ->
      @_addComment(text)

    _addComment: (text) ->
      if text
        updates =
          Text: text
          Artifact: @artifactRef
          User: app.session.get('user')?.get('_ref')
        new Discussion().save updates,
          wait: true
          patch: true
          success: (model, resp, options) =>
            @discussions.add model, at: 0
            @view.clearInputField()
