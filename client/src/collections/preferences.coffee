promise = require('es6-promise').Promise
appConfig = require 'app_config'
utils = require 'lib/utils'
Collection = require 'collections/collection'
Preference = require 'models/preference'

module.exports = class Preferences extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/preference'
  model: Preference

  fetchMobilePrefs: (user) ->
    @fetchAllPages(
      data:
        fetch: 'Name,Project,Value'
        query: "((Name CONTAINS \"mobile.\") AND (User = \"#{user.get('_ref')}\"))"
    )

  fetchWallPrefs: ->
    @fetchAllPages(
      data:
        fetch: 'Name,Value'
        query: "(Name CONTAINS \"wall.\")"
    )

  fetchWallPref: (projectId) ->
    @fetchAllPages(
      data:
        fetch: 'Name,Value'
        query: "(Name = \"wall.#{projectId}\")"
    )

  findPreference: (name) ->
    @find _.isAttributeEqual('Name', name)

  findProjectPreference: (project, name) ->
    @findPreference @_getProjectPreferenceName project, name

  updatePreference: (user, name, value) ->
    existingPref = newPref = @findPreference name

    changedAttrs = {}
    
    if existingPref
      if existingPref.get('Value') != value
        changedAttrs.Value = value || ''
    else
      changedAttrs =
        User: user
        Name: name
        Value: value

      newPref = new Preference changedAttrs

    Promise.resolve(
      unless _.isEmpty(changedAttrs)
        newPref.clientMetricsParent = this
        newPref.save changedAttrs, patch: true, success: (model) => @add newPref unless existingPref
    )

  updateProjectPreference: (user, project, name, value) ->
    existingPref = newPref = @findProjectPreference project, name

    changedAttrs = {}
    
    if existingPref
      if existingPref.get('Value') != value
        changedAttrs.Value = value || ''
    else
      changedAttrs =
        User: user
        Name: @_getProjectPreferenceName(project, name)
        Value: value

      newPref = new Preference changedAttrs

    Promise.resolve(
      unless _.isEmpty(changedAttrs)
        newPref.clientMetricsParent = this
        newPref.save changedAttrs, wait: false, patch: true, success: (model) => @add newPref unless existingPref
    )

  updateWallPreference: (user, value) ->
    @fetchWallPrefs().then =>
      project = value.project
      prefName = "wall.#{utils.getOidFromRef(project.get('_ref'))}"
      prefValue = JSON.stringify(_.omit(value, 'project'))
      
      existingPref = newPref = @findPreference prefName

      changedAttrs = {}
      
      if existingPref
        if existingPref.get('Value') != prefValue
          changedAttrs.Value = prefValue || ''
      else
        changedAttrs =
          Name: prefName
          Workspace: project.get('Workspace')._ref
          Value: prefValue

        newPref = new Preference changedAttrs

      Promise.resolve(
        unless _.isEmpty(changedAttrs)
          newPref.clientMetricsParent = this
          newPref.save changedAttrs, patch: true, success: (model) => @add newPref unless existingPref
      )

  _getProjectPreferenceName: (project, name) ->
    projectOid = utils.getOidFromRef(project)
    "#{name}.#{projectOid}"