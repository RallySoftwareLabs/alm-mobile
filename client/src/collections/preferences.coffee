define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Preference = require 'models/preference'

  class Preferences extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/preference'
    model: Preference

    fetchMobilePrefs: (cb) ->
      @fetch
        data:
          fetch: 'ObjectID,Name,Project,Value'
          query: "(Name CONTAINS \"mobile.\")"
        success: (collection, resp, options) =>
          cb?(null, collection)
        error: (collection, resp, options) =>
          cb?('auth', collection)

    findPreference: (name) ->
      @find _.isAttributeEqual('Name', name)

    findProjectPreference: (project, name) ->
      @find (pref) ->
        prefProj = pref.get('Project')
        (prefProj == project || prefProj?._ref == project) && pref.get('Name') == name

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

      unless _.isEmpty(changedAttrs)
        newPref.save changedAttrs, patch: true, success: (model) => @add newPref unless existingPref

    updateProjectPreference: (project, name, value) ->
      existingPref = newPref = @findProjectPreference project, name

      changedAttrs = {}
      
      if existingPref
        if existingPref.get('Value') != value
          changedAttrs.Value = value || ''
      else
        changedAttrs =
          Project: project
          Name: name
          Value: value

        newPref = new Preference changedAttrs

      unless _.isEmpty(changedAttrs)
        newPref.save changedAttrs, patch: true, success: (model) => @add newPref unless existingPref
