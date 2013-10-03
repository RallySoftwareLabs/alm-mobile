define ->
  moment = require 'moment'
  Handlebars = require 'handlebars'
  utils = require 'lib/utils'
  md = require 'md'

  # Put your handlebars.js helpers here.
  Handlebars.registerHelper 'date', (d) ->
    moment(d).format 'L'

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
      'blocked picto icon-blocked'
    else if ready
      'ready picto icon-ready'
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

  Handlebars.registerHelper 'toLowerCase', (value) ->
    return if _.isString(value) then value.toLowerCase() else ''

  Handlebars.registerHelper 'typeForDetailLink', (value) ->
    str = (value || '').toLowerCase()
    str = 'userstory' if str == 'hierarchicalrequirement'
    str

  Handlebars.registerHelper 'nonBreakingSpace', (value) ->
    return value if value
    new Handlebars.SafeString '&nbsp;'

  Handlebars.registerHelper 'md', (str) ->
    md str