define ->
  _ = require 'underscore'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  SwimlaneWallView = require 'views/wall/swimlane_wall'
  WallSplashView = require 'views/wall/splash'
  Features = require 'collections/features'
  UserStories = require 'collections/user_stories'
  Defects = require 'collections/defects'
  Projects = require 'collections/projects'
  Iterations = require 'collections/iterations'

  class SwimlaneWallController extends SiteController
   
    show: (project) ->
      @teams = new Projects() 
      @view = @renderReactComponent SwimlaneWallView, showLoadingIndicator: true, model: @teams, region: 'main'
      @updateTitle "Plan"
      @fetchTeams()
      @whenProjectIsLoaded project: project, showLoadingIndicator: false, fn: =>
        @updateTitle "Plan for #{app.session.getProjectName()}"
        projectRef = "/project/#{project}"

    fetchTeams: ->
      @teams.fetchAllPages
        data:
          fetch: 'Name'
          order: 'Name' 
          query: '(((((ObjectID = "9448887926") OR (ObjectID = "184289780")) OR (ObjectID = "1971104447")) OR (ObjectID = "6895507658")) OR (ObjectID = "2870644941"))'
        success: (teams) =>
          @fetchIterations team for team in teams.models

    fetchIterations: (team) =>
      team.iterations = new Iterations()
      projectRef = team.get('_ref') 
      team.iterations.fetch       
        data: 
          fetch: 'Name,StartDate,EndDate,PlannedVelocity,Notes,Theme,Project'
          query: '(EndDate > today)'
          order: 'EndDate'
          project: projectRef
          projectScopeUp: false
          projectScopeDown: false
          pagesize: 6
        success: =>
          this.view.forceUpdate()
          @fetchScheduledItems iteration for iteration in team.iterations.models

    fetchScheduledItems: (iteration) =>
      @fetchStories iteration
      @fetchDefects iteration

    fetchStories: (iteration) =>
      iteration.userStories = new UserStories()
      iterationRef = iteration.get('_ref')
      projectRef = iteration.get('Project')._ref
      iteration.userStories.fetch
        data:
          fetch: 'FormattedID,Name,Release,Iteration,Blocked'
          query: '(Iteration = ' + iterationRef + ')'
          order: 'Rank'
          project: projectRef
          projectScopeUp: false
          projectScopeDown: false
          pagesize: 50
        success: =>
          this.view.forceUpdate()

    fetchDefects: (iteration) =>
      iteration.defects = new Defects()      
      iterationRef = iteration.get('_ref')
      projectRef = iteration.get('Project')._ref
      iteration.defects.fetch
        data:
          fetch: 'FormattedID,Name,Release,Iteration,Blocked'
          query: '(Iteration = ' + iterationRef + ')'
          order: 'Rank'
          project: projectRef
          projectScopeUp: false
          projectScopeDown: false
          pagesize: 50
        success: =>
          this.view.forceUpdate()
  
