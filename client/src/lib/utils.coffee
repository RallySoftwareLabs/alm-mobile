define ->
  NAVIGATION_MODEL_TYPES =
    'hierarchicalrequirement': 'userstory'

  WSAPI_MODEL_TYPES = {}
  WSAPI_MODEL_TYPES[value] = key for key, value of NAVIGATION_MODEL_TYPES

  toBeReplaced = new RegExp('[\\s_\\.]', 'g')
  toBeRemoved = new RegExp('[\\+]', 'g')


  _.mixin
    capitalize: (string) ->
      string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()
    getAttribute: (attr) ->
      return -> @get(attr)

  return {
    getDetailHash: (model) ->
      attributes = model.attributes || model
      "#{@_getNavigationType(attributes._type)}/#{attributes.ObjectID}"

    getRef: (type, oid) ->
      "/#{@_getWsapiType(type)}/#{oid}"

    getOidFromRef: (ref) ->
      ref.substr (ref.lastIndexOf("/") + 1)

    getProfileImageUrl: (ref, size) ->
      baseUrl = window.AppConfig.almWebServiceBaseUrl
      "#{baseUrl}/profile/image/#{@getOidFromRef(ref)}/#{size}.sp"

    toCssClass: (value) ->
      str = value.toLowerCase();
      str = str.replace(toBeRemoved, '');
      str = str.trim();
      str = str.replace(toBeReplaced, '-');
      str = str.replace(/&nbsp;/g, '-');
      str = str.replace(/[^\w\-]/g, '-');
      str

    _getNavigationType: (type) ->
      type = type.toLowerCase()
      NAVIGATION_MODEL_TYPES[type] || type

    _getWsapiType: (type) ->
      type = type.toLowerCase()
      WSAPI_MODEL_TYPES[type] || type
  }