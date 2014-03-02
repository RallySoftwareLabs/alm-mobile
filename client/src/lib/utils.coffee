define ->
  Markdown = require 'pagedown'
  md = require 'md'
  appConfig = require 'appConfig'
  
  NAVIGATION_MODEL_TYPES =
    'hierarchicalrequirement': 'userstory'

  WSAPI_MODEL_TYPES = {}
  WSAPI_MODEL_TYPES[value] = key for key, value of NAVIGATION_MODEL_TYPES

  toBeReplaced = new RegExp('[\\s_\\.]', 'g')
  toBeRemoved = new RegExp('[\\+]', 'g')

  _.mixin
    capitalize: (string = '') ->
      string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()
    singularize: (string = '') ->
      switch string
        when 'Children' then 'Child'
        when 'UserStories' then 'User Story'
        else string.slice(0, -1)
    getAttribute: (attr) ->
      return -> @get(attr)
    isAttributeEqual: (attr, value) ->
      return (model) -> model.get(attr) == value
    areAttributesEqual: (attrs) ->
      return (model) ->
        _.every attrs, (value, attr) ->
          model.get(attr) == value 

  return {
    getDetailHash: (model) ->
      attributes = model.attributes || model
      "#{@_getNavigationType(@getTypeFromRef(attributes._ref).split('/')[0])}/#{@getOidFromRef(attributes._ref)}"

    getRef: (type, oid) ->
      "/#{@_getWsapiType(type)}/#{oid}"

    getOidFromRef: (ref) ->
      ref = ref._ref || ref
      ref.substr (ref.lastIndexOf("/") + 1)

    getTypeFromRef: (ref) ->
      return '' unless ref
      parts = ref.split '/'
      piIndex = _.indexOf(parts, 'portfolioitem')
      if piIndex > -1
        parts.slice(piIndex, piIndex + 2).join('/')
      else
        parts[parts.length - 2]

    getProfileImageUrl: (ref, size = 25) ->
      return "" unless ref
      baseUrl = appConfig.almWebServiceBaseUrl
      "#{baseUrl}/profile/image/#{@getOidFromRef(ref)}/#{size}.sp"

    ###*
     * Maps a collection to a Rally ALM WSAPI query string.
     *
     * @param {Collection} collection - The collection to convert to a query
     * @param {String} property - Which field to use as the property of the filter
     * @param {String} joinType - To AND or OR all the values
     * @param {Function} itemValueFn - A function to map each item in the collection to its value to filter on
     * @public
    ###
    createQueryFromCollection: (collection, property, joinType, itemValueFn) ->
      queryString = collection.reduce((result, item) ->
        value = itemValueFn(item)
        queryParam = "(#{property} = #{value})" 

        if result then "(#{result} #{joinType} #{queryParam})" else queryParam
      , "")

    toCssClass: (value) ->
      str = value.toLowerCase();
      str = str.replace(toBeRemoved, '');
      str = str.trim();
      str = str.replace(toBeReplaced, '-');
      str = str.replace(/&nbsp;/g, '-');
      str = str.replace(/[^\w\-]/g, '-');
      str

    getTypeForDetailLink: (value) ->
      str = (value || '').toLowerCase()
      str = 'userstory' if str == 'hierarchicalrequirement'
      str = 'portfolioitem' if _.contains(str, 'portfolioitem')
      str

    fixImageSrcs: (html) ->
      html && html.replace /src=\"\/slm/g, "src=\"#{appConfig.almWebServiceBaseUrl}"

    toMarkdown: (html = '') ->
      new Markdown.Converter().makeHtml(html).replace(/(\r\n|\n|\r)/gm,"");

    md: (str = '') -> md str

    _getNavigationType: (type) ->
      type = type.toLowerCase()
      NAVIGATION_MODEL_TYPES[type] || type

    _getWsapiType: (type) ->
      type = type.toLowerCase()
      WSAPI_MODEL_TYPES[type] || type
  }