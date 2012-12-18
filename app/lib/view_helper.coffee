# Put your handlebars.js helpers here.
Handlebars.registerHelper 'isEditing', (field, options) ->
  unless options?
    options = field
    field = null
  editing = false
  if field?
    editing = @edit is field
  else
    editing = @edit?

  if editing
    options.fn?(@)
  else
    options.inverse?(@)

Handlebars.registerHelper 'isFieldValue', (field, value, options) ->
  if @model[field] is value
    options.fn?(@)
  else
    options.inverse?(@)
