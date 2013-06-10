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

    getColumnHeaderAbbreviation: ->
      _.map(@model.get('value').replace(/-/g, ' ').split(' '), (word) -> word[0]).join ''

    onCardClick: (e) ->
      [oid, type] = e.currentTarget.id.split('-')
      @trigger 'cardclick', oid, type
      e.preventDefault()
  }