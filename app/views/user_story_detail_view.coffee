View = require('./view')
template = require('./templates/user_story_detail')
UserStory = require '../models/user_story'

module.exports = View.extend
  id: 'user-story-detail-view'
  template: template
  events:
    'click .controls.display.Name': 'startEditName'
    'click .controls.display.State': 'startEditState'
    'blur .controls input': 'saveModel'

  getRenderData: ->
    edit: @options.edit
    model: @model.toJSON()

  startEditName: (event) ->
    @_startEdit('Name')

  startEditState: (event) ->
    @_startEdit('State')

  _startEdit: (field) ->
    @options.edit = field
    @render()

  saveModel: (event) ->
    value = event.target.value
    field = event.target.id
    modelUpdates = {}
    modelUpdates[field] = value
    @model.save modelUpdates,
      wait: true
      patch: true
      success: =>
        @options.edit = null
        @render()
      error: =>
        debugger
