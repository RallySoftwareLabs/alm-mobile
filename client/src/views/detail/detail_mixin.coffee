define ->

  return {
    onSave: -> @trigger('save', @props.model)
    onCancel: -> @trigger('cancel')
  }