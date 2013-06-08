define ->
  hbs = require 'hbsTemplate'
  utils = require 'lib/utils'
  app = require 'application'
  PageView = require 'views/base/page_view'
  Discussion = require 'models/discussion'
  Discussions = require 'collections/discussions'
  DiscussionListView = require 'views/discussion/discussion_list_view'

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

      @_getInputField().focus()

    onKeyDown: (event) ->
      switch event.which
        when @keyCodes.ENTER_KEY then @_addComment()
      event.preventDefault()

    clearInputField: ->
      @_getInputField().focus()
      @_getInputField().val('')

    _onReplyClick: (event) ->
      text = @_getInputField().val()
      @trigger 'reply', text
      event.preventDefault()

    _getInputField: ->
      @.$('.reply input')
