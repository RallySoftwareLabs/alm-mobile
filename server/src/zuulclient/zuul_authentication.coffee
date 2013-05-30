Resource = require './resource'

module.exports = class ZuulAuthentication
  ROLES:
    0: 'SLMUser'
    1: 'SubscriptionAdmin'
    2: 'SLMAdmin'

  constructor: ->

  set: (@zuulResponse, @jsessionid, @securityToken) ->

  isAuthenticated: ->
    @zuulResponse && @securityToken #&& @jsessionid

  getName: -> @zuulResponse.username

  getAuthKey: -> new Resource(@zuulResponse.authKey)

  getRoles: -> (ROLES[role] for role in @zuulResponse.roles)

  getJSessionID: -> @jsessionid

  getSecurityToken: -> @securityToken
