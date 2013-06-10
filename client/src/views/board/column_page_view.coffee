define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  PageView = require 'views/base/page_view'
  ColumnViewMixin = require 'views/board/column_view_mixin'

  class ColumnPageView extends PageView
    region: 'main'
    className: 'board row-fluid'
    template: hbs['board/templates/column']

    _.extend @prototype, ColumnViewMixin

    initialize: ->
      super
      @initializeMixin()

      @updateTitle app.session.getProjectName()
      