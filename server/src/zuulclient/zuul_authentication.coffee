Resource = require './resource'

module.exports = class ZuulAuthentication
  ROLES:
    0: 'SLMUser'
    1: 'SubscriptionAdmin'
    2: 'SLMAdmin'

  constructor: (response) ->
    @authenticated = response?.statusCode is 200
    @jsonResponse = @authenticated and JSON.parse(response.body)

  isAuthenticated: -> @authenticated

  getName: -> @jsonResponse.username

  getAuthKey: -> new Resource(@jsonResponse.authKey)

  getRoles: -> (ROLES[role] for role in @jsonResponse.roles)
