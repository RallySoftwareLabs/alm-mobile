  methodMap =
    'create': 'POST',
    'update': 'POST', #'PUT',
    'patch':  'POST', #'PATCH',
    'delete': 'DELETE',
    'read':   'GET'
  
  origSync = Backbone.sync
  # Copied from backbone-0.9.9.js
  Backbone.sync = (method, model, options={}) ->
    headers = options.headers || {}
    headers.ZSESSIONID = $.fn.cookie('ZSESSIONID')
    options.headers = headers

    # origSync.call(Backbone, method, model, options)
    type = methodMap[method]

    # Default options, unless specified.
    _.defaults(options, {
      emulateHTTP: Backbone.emulateHTTP,
      emulateJSON: Backbone.emulateJSON
    })

    # Default JSON-request options.
    params = {type: type, dataType: 'json'}

    # Ensure that we have a URL.
    if !options.url
      params.url = _.result(model, 'url') or urlError()

    # Ensure that we have the appropriate request data.
    if (!options.data? and model and (method is 'create' or method is 'update' or method is 'patch'))
      params.contentType = 'application/json'
      params.data = JSON.stringify({model: (options.attrs or model.toJSON(options))}) #Rally Override!

    # For older servers, emulate JSON by encoding the request into an HTML-form.
    if options.emulateJSON
      params.contentType = 'application/x-www-form-urlencoded'
      params.data = if params.data then {model: params.data} else {}

    # For older servers, emulate HTTP by mimicking the HTTP method with `_method`
    # And an `X-HTTP-Method-Override` header.
    if (options.emulateHTTP and (type is 'PUT' or type is 'DELETE' or type is 'PATCH'))
      params.type = 'POST'

      if options.emulateJSON
        params.data._method = type

      beforeSend = options.beforeSend

      options.beforeSend = (xhr) ->
        xhr.setRequestHeader('X-HTTP-Method-Override', type)
        beforeSend?.apply(this, arguments)

    # Don't process data on a non-GET request.
    if (params.type isnt 'GET' and !options.emulateJSON)
      params.processData = false

    error = options.error
    options.error = (xhr, status, thrown) ->
      error?(model, xhr, options)
      model.trigger('error', model, xhr, options)
      if xhr.status is 401 or xhr.status is 0
        Backbone.history.navigate('/login', {trigger: true, replace: true})

    success = options.success
    options.success = (resp, status, xhr) ->
      if resp.OperationResult?.Errors?.length > 0
        options.error(xhr, "ws", null)
      else
        success?(resp, status, xhr)
        model.trigger('sync', model, resp, options)

    # Make the request, allowing the user to override any Ajax options.
    xhr = Backbone.ajax(_.extend(params, options))
    model.trigger('request', model, xhr, options)
    xhr
  # Backbone.sync = origSync
