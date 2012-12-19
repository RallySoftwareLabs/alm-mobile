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

  id: 'home-view'
  template: template
  events:
    'click #user-stories-nav-button #defects-nav-button #tasks-nav-button': 'showWorkItems'

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

    @

  load: ->
    $('#content').html("<h1>Loading Data</h1>").spin()

    @fetchUserStories()
    @fetchDefects()
    @fetchTasks()

    @render()
    # $('#content').html(@el)
    # @hideAll()
    $('#user_stories_view').show()

  render: ->
    @$el.html @template()
    @

  appendChildView: (view) ->
    @$el.append(view.render().el)
    $('#content').html(@el)
    # Hide the appended item unless its user stories?

  fetchUserStories: ->
    @userStories.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        @appendChildView(@userStoriesView)
      failure: (collection, xhr, options) =>
        @error = true
    })

  fetchDefects: ->
    @defects.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        @appendChildView(@defectView)
      failure: (collection, xhr, options) =>
        @error = true
    })

  fetchTasks: ->
    @tasks.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) =>
        @appendChildView(@taskView)    
      failure: (collection, xhr, options) =>
        @error = true
    })

  showWorkItems: (event) -> 
    @hideAll
    $(event.source_element).show()

  hideAll: ->
    $('#user-stories-view').hide()
    $('#defects-view').hide()
    $('#tasks-view').hide()

  # hideAll: (event) ->
  #   _.each($('#nav li'), (elment, index, list) -> element.hide())

