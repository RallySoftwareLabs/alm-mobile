define ->
  _ = require 'underscore'
  React = require 'react'
  app = require 'application'

  return {
    getAllowedValues: ->
      if app.session.get('boardField') == @props.field
        boardColumns = app.session.getBoardColumns()
        return boardColumns if _.contains(boardColumns, @getFieldValue())

      av = @props.item.getAllowedValues?(@props.field)
      av && _.pluck(av, 'StringValue')

    getFieldValue: ->
      @props.value || @props.item.get(@props.field)
      
    saveModel: (updates, opts) ->
      @publishEvent 'saveField', updates, opts
      @props.item.set updates

    startEdit: ->
      @setState editMode: true

    endEdit: (event) ->
      try
        value = (@parseValue || @_parseValue)(event.target.value)
        field = @props.field
        event.preventDefault()
        if @props.item.get(field) isnt value
          modelUpdates = {}
          modelUpdates[field] = value
          @saveModel modelUpdates

        @setState editMode: false if @props.item.get('ObjectID')
      catch e

    routeTo: (route) ->
      @publishEvent('!router:route', route);

    _parseValue: (value) ->
      val = value
      if @props.inputType == 'number'
        val = _.parseInt(value)
        throw new Error(value + ' is not a number') if val == NaN

      val

    onKeyDown: (event) ->
      switch event.which
        when @keyCodes.ENTER_KEY then @endEdit event
        when @keyCodes.ESCAPE_KEY then @_switchToViewMode()

    getInputMarkup: ->
      React.DOM.input(
        type: @props.inputType || "text"
        className: "editor #{@props.field}"
        placeholder: @props.field
        defaultValue: @getFieldValue()
        onBlur: @endEdit
        onKeyDown: @onKeyDown
      )
  }
