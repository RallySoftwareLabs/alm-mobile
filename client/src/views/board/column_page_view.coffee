define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  PageView = require 'views/base/page_view'
  ColumnViewMixin = require 'views/board/column_view_mixin'

  class ColumnPageView extends PageView
    region: 'main'
    className: 'board row-fluid'
    template: hbs['board/templates/column']
    abbreviateHeader: false
    showFields: true

    _.extend @prototype, ColumnViewMixin

    events:
      'click .go-left': 'goLeft'
      'click .go-right': 'goRight'

    initialize: (options = {}) ->
      super
      @columns = options.columns
      @initializeMixin()

      @updateTitle app.session.getProjectName()
      
    goLeft: (e) ->
      @trigger 'goleft', @model
      e.preventDefault()
      
    goRight: (e) ->
      @trigger 'goright', @model
      e.preventDefault()