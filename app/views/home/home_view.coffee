# Required views/templates
View = require '../view'
template = require './templates/home'
UserStoriesView = require './user_stories_view'
DefectsView = require './defects_view'
TasksView = require './tasks_view'
# Required Models
UserStoryCollection = require 'models/user_story_collection'
DefectCollection = require 'models/defect_collection'
TaskCollection = require 'models/task_collection'

module.exports = View.extend

  initialize: ->
    # @constructor.__super__.initialize.apply @, [options]
    @error = false

    @userStories = new UserStoryCollection()
    @defects = new DefectCollection()
    @tasks = new TaskCollection()

    @userStoriesView = new UserStoriesView
      model: @userStories

    @defectView = new DefectsView
      model: @defects

    @taskView = new TasksView
      model: @tasks

  id: 'home-view'
  template: template
  events:
    'click #user-stories-nav-button': 'showStories'
    'click #defects-nav-button': 'showDefects'
    'click #tasks-nav-button': 'showTasks'

  render: (callback) ->
    @$el.html @template()
    @addRenderedChildren()
    @

  addRenderedChildren: ->
    @$el.append(@userStoriesView.render().el)
    @$el.append(@defectView.render().el)
    @$el.append(@taskView.render().el)

  fetchAll: ->
    @fetchUserStories()
    @fetchDefects()
    @fetchTasks()

  fetchUserStories: ->
    @userStories.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        $('#content').html(@render().el)
      failure: (collection, xhr, options) =>
        @error = true
        $('#content').html(@render().el)
    })

  fetchDefects: ->
    @defects.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        $('#content').html(@render().el)
      failure: (collection, xhr, options) =>
        @error = true
        $('#content').html(@render().el)
    })

  fetchTasks: ->
    @tasks.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        $('#content').html(@render().el)
      failure: (collection, xhr, options) =>
        @error = true
        $('#content').html(@render().el)
    })

  showStories: (event) ->
    @hideAll()
    $('#user-stories-view').show()

  showDefects: (event) ->
    @hideAll()
    $('#defects-view').show()

  showTasks: (event) ->
    @hideAll()
    $('#tasks-view').show()

  hideAll: ->
    $('#user-stories-view').hide()
    $('#defects-view').hide()
    $('#tasks-view').hide()

