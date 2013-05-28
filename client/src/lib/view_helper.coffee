define ['lib/utils'], (utils) ->

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

  Handlebars.registerHelper 'state', (blocked, ready) ->
    if blocked
      'blocked'
    else if ready
      'ready'
    else
      ''

  Handlebars.registerHelper 'profileImageUrl', (ref, size, options) ->
    utils.getProfileImageUrl(ref, size)

  Handlebars.registerHelper 'createdAt', (created) ->
    _(created).capitalize()

  Handlebars.registerHelper 'selectOption', (option, selectedValue) ->
    str = "<option value=\"#{option}\""
    str += " selected=\"selected\"" if selectedValue is option
    str += ">#{option}</option>"
    str