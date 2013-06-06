define [
  'application'
  'hbsTemplate'
  'views/base/page_view'
], (app, hbs, PageView) ->

  class ColumnPageView extends PageView
    region: 'main'
    className: 'board row-fluid'
    template: hbs['board/templates/column']

    initialize: ->
      super
      @model.synced => @render()
      @delegate 'click', '.card', @onCardClick

      @updateTitle app.session.getProjectName()
      
    getTemplateData: ->
      storiesAndDefects = @model.stories.toJSON().concat(@model.defects.toJSON())
      header = @model.get('value') + (if @model.isSynced() then " (#{storiesAndDefects.length})" else " ...")
      data = 
        header: header
        cards: storiesAndDefects

    onCardClick: (e) ->
      [oid, type] = e.currentTarget.id.split('-')
      @trigger 'cardClick', oid, type