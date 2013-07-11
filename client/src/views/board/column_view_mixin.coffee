define ->
  _ = require 'underscore'
  app = require 'application'

  return {
    initializeMixin: ->
      @model.synced => @render()
      @delegate 'click', '.header', => @trigger 'headerclick', @model
      @delegate 'click', '.card', @onCardClick

    getTemplateData: ->
      storiesAndDefects = _.sortBy @model.artifacts().serialize(), 'Rank'
      header = @getColumnHeaderAbbreviation() + (if @model.isSynced() then " (#{storiesAndDefects.length})" else " ...")
      data = 
        header: header
        cards: storiesAndDefects
        showFields: @showFields
        canGoLeft: @showFields && !@isColumnAtIndex(0)
        canGoRight: @showFields && !@isColumnAtIndex(@columns.length - 1)
        iteration: @showIteration && app.session.get('iteration')?.toJSON()

    getColumnHeaderAbbreviation: ->
      fieldValue = @model.get('value')

      return if @abbreviateHeader
        _.map(fieldValue.replace(/-/g, ' ').split(' '), (word) -> word[0]).join ''
      else
        fieldValue

    isColumnAtIndex: (index) ->
      @columns[index]?.get('value') == @model.get('value')

    onCardClick: (e) ->
      [oid, type] = e.currentTarget.id.split('-')
      @trigger 'cardclick', oid, type
      e.preventDefault()
  }