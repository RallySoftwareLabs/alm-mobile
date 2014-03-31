ReconnectingWebSocket = require 'reconnecting-websocket'
Projects = require 'collections/projects'

module.exports = {

	listenForRealtimeUpdates: (options, callback, scope) ->
	  project = options.project

	  websocket = new ReconnectingWebSocket('wss://realtime.rally1.rallydev.com/_websocket')
	  websocket.onopen = =>
	    Projects.fetchAll().then (allProjects) =>
	      projectsToSubscribeTo = @_createProjectScopeDownTree(allProjects, project)
	      _.each projectsToSubscribeTo, (projectUuid) =>
	        websocket.send JSON.stringify({
	          "uri": "/_subscribe",
	          "request-method": "post",
	          "body": { "topic": projectUuid }
	        })

	  websocket.onmessage = (msg) =>
	    msgData = JSON.parse(msg.data).data
	    return unless msgData
	    callback.call scope, @_translateMessage(msgData)

	  websocket

	_createProjectScopeDownTree: (allProjects, project) ->

	  parentChildHash = allProjects.reduce (acc, p) ->
	    uuid = p.get('_refObjectUUID')
	    parentUuid = p.get('Parent')?._refObjectUUID
	    return acc unless parentUuid

	    if !acc[parentUuid]
	      acc[parentUuid] = []
	    acc[parentUuid].push(uuid)
	    acc
	  , {}

	  _searchDown = (projectsInScope, currentUuid) =>
	    projectsInScope.push currentUuid
	    _.each(parentChildHash[currentUuid], _.partial(_searchDown, projectsInScope))
	    projectsInScope

	  _searchDown([], project.get('_refObjectUUID'))

	_translateMessage: (msg) ->
	  newMsg = _.transform msg, (newObj, value, key) ->
	    switch key
	      when 'id', 'transaction', 'action' then newObj[key] = value
	      when 'changes', 'state' then newObj[key] = @_convertStateObj(value)
    , {}, this

    newMsg.modelType = newMsg.state.object_type
    newMsg

  _convertStateObj: (state) ->
    _.transform state, (newObj, value, key) ->
      newObj[value.name] = value.value
      true
}