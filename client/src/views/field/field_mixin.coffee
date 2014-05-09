_ = require 'underscore'
React = require 'react'
utils = require 'lib/utils'

focusEditor = ->
  if @isEditMode() && @_isExistingObject()
    @$('.editor').focus();

module.exports = {
  componentDidMount: focusEditor
  componentDidUpdate: focusEditor

  getAllowedValues: ->
    av = null
    if @props.allowedValues
      av = _.map(@props.allowedValues, (value) ->
        value: if _.isObject(value.AllowedValueType) then value._ref else value.StringValue
        label: value.StringValue
      )
      if @props.reverseAllowedValues
        av = av.reverse()

    av

  getFieldValue: ->
    @props.value || @props.item.get(@props.field)

  getFieldDisplayValue: ->
    val = @getFieldValue()
    if _.isObject(val) then val._refObjectName else val

  getFieldId: ->
    "#{utils.toCssClass(@props.field)}-field"

  getFieldAttribute: ->
    @props.item.getAttribute(@props.field)

  getFieldDisplayName: ->
    @getFieldAttribute().Name

  getFieldAriaLabel: ->
    fieldDisplayName = @getFieldDisplayName()
    label = "#{fieldDisplayName} field. "
    label += if @getFieldAttribute().AttributeType == "COLLECTION"
      fieldValue = @getFieldValue()
      (if fieldValue then "This item has #{fieldValue.Count} #{fieldDisplayName}" else "This item is still loading") + ". Click to view and add #{fieldDisplayName}."
    else
      "Current value is #{@getFieldDisplayValue()}. Click to Edit."
    label
    
  saveModel: (updates, opts) ->
    @publishEvent 'saveField', this, updates, opts

  isEditMode: ->
    if @state?.editMode? then @state.editMode else @props.editMode

  startEdit: ->
    @publishEvent 'startEdit', this, @props.field

  endEdit: (e) ->
    try
      value = (@parseValue || @_parseValue)(e.target.value)
      field = @props.field
      e.preventDefault()
      if @props.item.get(field) isnt value
        modelUpdates = {}
        modelUpdates[field] = value
        @saveModel modelUpdates
      if @_isExistingObject()
        @setState( editMode: false, => @getFocusNode?().focus() )
    catch e

  _parseValue: (value) ->
    val = value
    if @props.inputType == 'number'
      val = _.parseInt(value)
      throw new Error(value + ' is not a number') if val == NaN

    val

  onKeyDown: (event) ->
    switch event.key
      when "Enter" then @endEdit event
      when "Esc", "Escape"
        @setState editMode: false, -> @getFocusNode?().focus()

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

  _isExistingObject: -> @props.item.get('_ref')
}
