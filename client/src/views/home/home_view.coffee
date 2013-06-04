define [
  'chaplin'
  'hbsTemplate'
  'application'
  'views/base/page_view'
  'views/home/user_stories_view'
  'views/home/defects_view'
  'views/home/tasks_view'
  'collections/user_stories'
  'collections/defects'
  'collections/tasks'
], (Chaplin, hbs, app, PageView, UserStoriesView, DefectsView, TasksView, UserStories, Defects, Tasks) ->
  class HomeView extends PageView
    region: 'main'
    template: hbs['home/templates/home']

    listen:
      'projectready mediator': 'updateTitle'

    events:
      'click .btn-block': 'onButton'

    initialize: (options) ->
      super

      @error = false

      @currentTab = options.tab || "userstories"

      @

    afterRender: ->
      if app.session.project?
        @load()
      else
        @subscribeEvent 'projectready', @onProjectReady

    getTemplateData: ->
      createRoute: @_getCreateRoute()
      tabs: @_getTabs()

    onProjectReady: ->
      @unsubscribeEvent 'projectready', @onProjectReady
      @load()

    load: ->
      @updateTitle()

      switch @currentTab
        when 'userstories' then @fetchUserStories()
        when 'tasks' then @fetchTasks()
        when 'defects' then @fetchDefects()

    fetchUserStories: ->
      userStories = new UserStories()

      @userStoriesView = new UserStoriesView
        container: @$('#userstories-view .listing')
        collection: userStories

      userStories.fetch(
        data:
          fetch: ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked'].join ','
          query: "(Project = #{app.session.project.get('_ref')})"
          order: "CreationDate DESC,ObjectID"
        success: (collection, response, options) =>
          @userStoriesView.render()
        failure: (collection, xhr, options) =>
          @error = true
      )

    fetchTasks: ->
      tasks = new Tasks()
      @tasksView = new TasksView
        container: @$('#tasks-view .listing')
        collection: tasks
      tasks.fetch(
        data:
          fetch: ['ObjectID', 'FormattedID', 'Name', 'Ready', 'Blocked', 'ToDo'].join ','
          query: "(Project = #{app.session.project.get('_ref')})"
          order: "CreationDate DESC,ObjectID"
        # success: (collection, response, options) =>
        #   @tasksView.render()
        failure: (collection, xhr, options) =>
          @error = true
      )

    fetchDefects: ->
      defects = new Defects()
      @defectsView = new DefectsView
        container: @$('#defects-view .listing')
        collection: defects
      defects.fetch(
        data:
          fetch: ['ObjectID', 'FormattedID', 'Name'].join ','
          query: "(Project = #{app.session.project.get('_ref')})"
          order: "CreationDate DESC,ObjectID"
        # success: (collection, response, options) =>
        #   @defectsView.render()
        failure: (collection, xhr, options) =>
          @error = true
      )

    onButton: (event) ->
      url = event.currentTarget.id
      @publishEvent '!router:route', url

    updateTitle: ->
      @publishEvent 'updatetitle', [_.find(@_getTabs(), active: true).value, app.session.getProjectName()].join ' in '

    _getCreateRoute: ->
      map =
        userstories: 'userstory'
        tasks: 'task'
        defects: 'defect'
      "new/#{map[@currentTab]}"

    _getTabs: ->
      [
        {
          key: 'userstories'
          value: 'Stories'
          active: @currentTab == 'userstories'
        }
        {
          key: 'tasks'
          value: 'Tasks'
          active: @currentTab == 'tasks'
        }
        {
          key: 'defects'
          value: 'Defects'
          active: @currentTab == 'defects'
        }
      ]