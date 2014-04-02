_ = require 'underscore'
app = require 'application'
SiteController = require 'controllers/base/site_controller'
SwimlaneWallView = require 'views/wall/swimlane_wall'
SwimlaneLegendView = require 'views/wall/swimlane_legend'
WallSplashView = require 'views/wall/splash'
UserStories = require 'collections/user_stories'
Defects = require 'collections/defects'
Projects = require 'collections/projects'
Iterations = require 'collections/iterations'

module.exports = class SwimlaneWallController extends SiteController
 
  show: (project) ->
    @teams = new Projects() 
    @fetchTeams()
    @view = @renderReactComponents(
      [{
        componentClass: SwimlaneWallView
        props: 
          showLoadingIndicator: true
          model: @teams
          region: 'main'
          changeOptions: 'complete'
      }, {
        componentClass: SwimlaneLegendView
        props:
          region: 'bottom'
      }]
    )
    @updateTitle "Plan"
    # @whenProjectIsLoaded project: project, showLoadingIndicator: false, fn: =>
    #   @updateTitle "Plan for #{app.session.getProjectName()}"
      # projectRef = "/project/#{project}"

  fetchTeams: ->
    @teams.fetchAllPages
      data:
        fetch: 'Name'
        order: 'Name' 
        query: '(((((ObjectID = "9448887926") OR (ObjectID = "184289780")) OR (ObjectID = "1971104447")) OR (ObjectID = "6895507658")) OR (ObjectID = "2870644941"))'
      success: (teams) =>
        teams.each @fetchIterations, this

  fetchIterations: (team) =>
    team.iterations = new Iterations()
    team.iterations.team = team
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
        team.trigger('add')
        team.iterations.each @fetchScheduledItems, this

  fetchScheduledItems: (iteration) =>
    $.when(
      @fetchStories(iteration),
      @fetchDefects(iteration)
    ).then =>
      iteration.collection.team.trigger('change')

  fetchStories: (iteration) =>
    iteration.userStories = new UserStories()
    iterationRef = iteration.get('_ref')
    projectRef = iteration.get('Project')._ref
    iteration.userStories.fetch
      data:
        fetch: 'FormattedID,Name,Release,Iteration,PlanEstimate,Blocked'
        query: '(Iteration = ' + iterationRef + ')'
        order: 'Rank'
        project: projectRef
        projectScopeUp: false
        projectScopeDown: false
        pagesize: 50

  fetchDefects: (iteration) =>
    iteration.defects = new Defects()      
    iterationRef = iteration.get('_ref')
    projectRef = iteration.get('Project')._ref
    iteration.defects.fetch
      data:
        fetch: 'FormattedID,Name,Release,Iteration,PlanEstimate,Blocked'
        query: '(Iteration = ' + iterationRef + ')'
        order: 'Rank'
        project: projectRef
        projectScopeUp: false
        projectScopeDown: false
        pagesize: 50

  # dispose: ->
  #   React.unmountComponentAtNode(document.getElementsByClassName('navbar-fixed-bottom')[0])
