app = require 'application'

$(->
  app.initialize()
  Backbone.history.start(
    root: '/m'
    # pushState: true
  )
  $(document).on 'click', 'a:not([data-bypass])', (evt) ->

    href = $(this).attr('href')
    protocol = this.protocol + '//'

    if href.slice(protocol.length) isnt protocol
      evt.preventDefault()
      app.router.navigate(href, true)

  methodMap =
    'create': 'POST',
    'update': 'POST', #'PUT',
    'patch':  'PATCH',
    'delete': 'DELETE',
    'read':   'GET'
  
  # origSync = Backbone.sync
  # # Copied from backbone-0.9.9.js
  # Backbone.sync = (method, model, options={}) ->
  #   type = methodMap[method]

  #   # Default options, unless specified.
  #   _.defaults(options, {
  #     emulateHTTP: Backbone.emulateHTTP,
  #     emulateJSON: Backbone.emulateJSON
  #   })

  #   # Default JSON-request options.
  #   params = {type: type, dataType: 'json'}

  #   # Ensure that we have a URL.
  #   if !options.url
  #     params.url = _.result(model, 'url') or urlError()

  #   # Ensure that we have the appropriate request data.
  #   if (options.data == null and model and (method is 'create' or method is 'update' or method is 'patch'))
  #     params.contentType = 'application/json'
  #     params.data = JSON.stringify(options.attrs or model.toJSON(options))

  #   # For older servers, emulate JSON by encoding the request into an HTML-form.
  #   if options.emulateJSON
  #     params.contentType = 'application/x-www-form-urlencoded'
  #     params.data = if params.data then {model: params.data} else {}

  #   # For older servers, emulate HTTP by mimicking the HTTP method with `_method`
  #   # And an `X-HTTP-Method-Override` header.
  #   if (options.emulateHTTP and (type is 'PUT' or type is 'DELETE' or type is 'PATCH'))
  #     params.type = 'POST'

  #     if options.emulateJSON
  #       params.data._method = type

  #     beforeSend = options.beforeSend

  #     options.beforeSend = (xhr) ->
  #       xhr.setRequestHeader('X-HTTP-Method-Override', type)
  #       beforeSend?.apply(this, arguments)

  #   # Don't process data on a non-GET request.
  #   if (params.type isnt 'GET' and !options.emulateJSON)
  #     params.processData = false

  #   success = options.success
  #   options.success = (resp, status, xhr) ->
  #     success?(resp, status, xhr)
  #     model.trigger('sync', model, resp, options)

  #   error = options.error
  #   options.error = (xhr, status, thrown) ->
  #     error?(model, xhr, options)
  #     model.trigger('error', model, xhr, options)

  #   # Make the request, allowing the user to override any Ajax options.
  #   xhr = Backbone.ajax(_.extend(params, options))
  #   model.trigger('request', model, xhr, options)
  #   xhr
  # Backbone.sync = origSync
)
