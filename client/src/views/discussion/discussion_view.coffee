define [
  'hbsTemplate'
  'lib/utils'
  'application'
  'views/view'
  'models/discussion'
  'collections/discussions'
  'views/discussion/discussion_list_view'
], (hbs, utils, app, View, Discussion, Discussions, DiscussionListView) ->

  class DiscussionView extends View
    
    template: hbs['discussion/templates/discussion']

    className: 'discussion-page'

    initialize: (config) ->
      super config
      @ref = utils.getRef(config.type, config.oid)
      @model = new Discussions()

    events: ->
      return {
        'click .reply button': '_onReplyClick'
        'submit form': '_addComment'
      }

    afterRender: ->
      @listView = new DiscussionListView(
        el: this.$(".listing")
        model: @model
        artifact: @ref
      )
      @_getInputField()[0].focus()

    remove: ->
      @listView.remove()
      super

    onKeyDown: (event) ->
      switch event.which
        when @ENTER_KEY then @_addComment()
      event.preventDefault()

    _onReplyClick: (event) ->
      @_addComment()
      event.preventDefault()

    _addComment: ->
      text = @_getInputField().val()
      if text
        updates =
          Text: text
          Artifact: @ref
          User: app.session.user?.get('_ref')
        new Discussion().save updates,
          wait: true
          patch: true
          success: (model, resp, options) =>
            @model.add model, at: 0
            @listView.render()
            @_getInputField()[0].focus()
            @_getInputField()[0].value = ''
          error: =>
            debugger

    _getInputField: ->
      @.$('.reply input')