RESOURCE_PATTERN = /([^\/]+)\/([^\/]+)\.js/
module.exports = class Resource
  constructor: (resource) ->
    regexMatch = RESOURCE_PATTERN.exec resource._ref
    @type = regexMatch[1]
    @id = regexMatch[2]

  getId: -> @id
  getType: -> @type