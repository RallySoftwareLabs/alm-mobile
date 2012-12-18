# Put your handlebars.js helpers here.
Handlebars.registerHelper 'isEditing', (field, options) ->
  if @edit is field
    options.fn?(@)
  else
    options.inverse?(@)

Handlebars.registerHelper 'isFieldValue', (field, value, options) ->
  if @model[field] is value
    options.fn?(@)
  else
    options.inverse?(@)
