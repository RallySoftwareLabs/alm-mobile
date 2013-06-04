define [
  'application'
  'lib/utils'
  'models/discussion'
  'collections/discussions'
	'controllers/base/site_controller'
	'views/discussion/discussion_page_view'
], (app, utils, Discussion, Discussions, SiteController, DiscussionPageView) ->
	class DiscussionController extends SiteController
    show: (params) ->
      @discussions = new Discussions()

      @artifactRef = utils.getRef(params.type, params.id)

      @view = new DiscussionPageView
        region: 'main'
        autoRender: true
        collection: @discussions

      @listenTo @view, 'reply', @_onReplyClick

      @discussions.fetch
        data:
          fetch: "Text,User,Artifact,CreationDate"
          query: "(Artifact = #{@artifactRef})"
          order: "CreationDate DESC,ObjectID"
        # success: (collection, response, options) =>
        #   @render()

    _onReplyClick: (text) ->
      @_addComment(text)

    _addComment: (text) ->
      if text
        updates =
          Text: text
          Artifact: @artifactRef
          User: app.session.user?.get('_ref')
        new Discussion().save updates,
          wait: true
          patch: true
          success: (model, resp, options) =>
            @discussions.add model, at: 0
            @view.clearInputField()
          error: =>
            debugger