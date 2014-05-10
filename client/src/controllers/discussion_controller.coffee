app = require 'application'
utils = require 'lib/utils'
Discussion = require 'models/discussion'
Discussions = require 'collections/discussions'
SiteController = require 'controllers/base/site_controller'
DiscussionView = require 'views/discussion/discussion'

module.exports = class DiscussionController extends SiteController
  show: (type, id) ->
    @whenProjectIsLoaded ->
      @discussions = new Discussions()

      @artifactRef = utils.getRef(type, id)

      @renderReactComponent DiscussionView, model: @discussions, region: 'main'

      @subscribeEvent 'reply', @onReplyClick

      @discussions.fetch(
        data:
          shallowFetch: "Text,User,CreationDate"
          query: "(Artifact = #{@artifactRef})"
          order: "CreationDate DESC"
      ).then => @markFinished()

  onReplyClick: (view, text) ->
    if text
      updates =
        Text: text
        Artifact: @artifactRef
        User: app.session.get('user')?.get('_ref')
      discussion = new Discussion()
      discussion.clientMetricsParent = this
      discussion.save updates,
        wait: true
        patch: true
        success: (model, resp, options) =>
          @discussions.add model, at: 0
          view.clearInputField()
