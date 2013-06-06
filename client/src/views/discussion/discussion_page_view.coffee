define [
  'hbsTemplate'
  'lib/utils'
  'application'
  'views/base/page_view'
  'models/discussion'
  'collections/discussions'
  'views/discussion/discussion_list_view'
], (hbs, utils, app, PageView, Discussion, Discussions, DiscussionListView) ->

  class DiscussionPageView extends PageView
    
    template: hbs['discussion/templates/discussion_page']

    className: 'discussion-page'

    events:
      'click .reply button': '_onReplyClick'
      'submit form': '_onReplyClick'

    afterRender: ->
      listView = new DiscussionListView(
        container: @$(".listing")
        collection: @collection
      )
      @subview 'list', listView

      @_getInputField()[0].focus()

    onKeyDown: (event) ->
      switch event.which
        when @ENTER_KEY then @_addComment()
      event.preventDefault()

    clearInputField: ->
      @_getInputField()[0].focus()
      @_getInputField()[0].value = ''

    _onReplyClick: (event) ->
      text = @_getInputField().val()
      @trigger 'reply', text
      event.preventDefault()

    _getInputField: ->
      @.$('.reply input')