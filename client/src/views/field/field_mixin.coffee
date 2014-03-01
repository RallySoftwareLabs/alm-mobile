define ->
  _ = require 'underscore'
  React = require 'react'
  app = require 'application'
  focusEditor = ->
    if @isEditMode() && @props.item.get('ObjectID')
      @$('.editor').focus();

  return {
    componentDidMount: focusEditor
    componentDidUpdate: focusEditor

    getAllowedValues: ->
      av = @props.allowedValues
      if app.session.get('boardField') == @props.field
        boardColumns = app.session.getBoardColumns()
        if _.contains(boardColumns, @getFieldValue())
          av = _.filter av, (value) ->
            _.contains(boardColumns, value.StringValue)
        else
          av = null

      av && _.map(av, (value) ->
        value: if _.isObject(value.AllowedValueType) then value._ref else value.StringValue
        label: value.StringValue
      )

    getFieldValue: ->
      @props.value || @props.item.get(@props.field)

    getFieldDisplayValue: ->
      val = @getFieldValue()
      if _.isObject(val) then val._refObjectName else val
      
    saveModel: (updates, opts) ->
      @publishEvent 'saveField', updates, opts

    isEditMode: ->
      @props.editMode || @state?.editMode

    startEdit: ->
      @publishEvent 'startEdit', this, @props.field

    endEdit: (event) ->
      try
        value = (@parseValue || @_parseValue)(event.target.value)
        field = @props.field
        event.preventDefault()
        if @props.item.get(field) isnt value
          modelUpdates = {}
          modelUpdates[field] = value
          @saveModel modelUpdates

        @publishEvent 'endEdit', this, @props.field
      catch e

    routeTo: (route) ->
      @publishEvent('router:route', route);

    _parseValue: (value) ->
      val = value
      if @props.inputType == 'number'
        val = _.parseInt(value)
        throw new Error(value + ' is not a number') if val == NaN

      val

    onKeyDown: (event) ->
      switch event.which
        when @keyCodes.ENTER_KEY then @endEdit event
        when @keyCodes.ESCAPE_KEY then @setState editMode: false

    getInputMarkup: ->
      React.DOM.input(
        type: @props.inputType || "text"
        className: "editor #{@props.field}"
        placeholder: @props.field
        defaultValue: @getFieldValue()
        onBlur: @endEdit
        onKeyDown: @onKeyDown
      )

    getAllowedValuesSelectMarkup: ->
      field = @props.field
      options = _.map @getAllowedValues(), (val) ->
        value = val.value
        label = val.label || 'None'
        React.DOM.option( {value: value,  key: field + value },  label )

      defaultValue = @getFieldValue()
      if _.isObject(defaultValue)
        defaultValue = defaultValue._ref
      
      React.DOM.select(
        {
          className: "editor " + @props.field
          defaultValue: defaultValue
          onBlur: @endEdit
          onKeyDown: @onKeyDown
        },
        options
      )

    getEmptySpanMarkup: ->
      React.DOM.span(
        dangerouslySetInnerHTML:
          __html: '&nbsp;'
      )
  }
