define ->
  Handlebars = require 'handlebars'
  utils = require 'lib/utils'

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

  Handlebars.registerHelper 'objectIDFromRef', (ref) ->
    utils.getOidFromRef ref

  Handlebars.registerHelper 'selectOption', (value, label, selectedValue) ->
    str = "<option value=\"#{value}\""
    str += " selected=\"selected\"" if selectedValue is value
    str += ">#{label}</option>"
    str

  Handlebars.registerHelper 'toCssClass', (value) ->
    utils.toCssClass value
