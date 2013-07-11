define ->
  _ = require 'underscore'
  app = require 'application'
  utils = require 'lib/utils'
  hbs = require 'hbsTemplate'
  PageView = require 'views/base/page_view'
  ColumnView = require 'views/board/column_view'

  class BoardPageView extends PageView
    region: 'main'
    className: 'board row-fluid'
    template: hbs['board/templates/board']

    initialize: (options = {}) ->
      super
      @columns = options.columns
      @field = options.field

      @updateTitle app.session.getProjectName()

    afterRender: ->
      _.map @columns, (col) =>
        colView = new ColumnView autoRender: true, model: col, columns: @columns, container: "#col-#{utils.toCssClass(col.get('value'))}"
        @subview colView
        @bubbleEvent colView, 'headerclick', 'headerclick'
        @bubbleEvent colView, 'cardclick', 'cardclick'

    getTemplateData: ->
      columns: _.invoke @columns, _.getAttribute('value')
      iteration: app.session.get('iteration')?.toJSON()