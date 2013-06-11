define ->

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

    getColumnHeaderAbbreviation: ->
      fieldValue = @model.get('value')

      return if @abbreviateHeader
        _.map(fieldValue.replace(/-/g, ' ').split(' '), (word) -> word[0]).join ''
      else
        fieldValue

    onCardClick: (e) ->
      [oid, type] = e.currentTarget.id.split('-')
      @trigger 'cardclick', oid, type
      e.preventDefault()
  }