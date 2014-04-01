_ = require 'underscore'
app = require 'application'
appConfig = require 'app_config'
utils = require 'lib/utils'
SiteController = require 'controllers/base/site_controller'
WallView = require 'views/wall/wall'
WallCreateView = require 'views/wall/create'
WallSplashView = require 'views/wall/splash'
PortfolioItemModelFactory = require 'lib/portfolio_item_model_factory'
Preferences = require 'collections/preferences'
Projects = require 'collections/projects'
UserStories = require 'collections/user_stories'
Project = require 'models/project'
UserStory = require 'models/user_story'
PortfolioItem = require 'models/portfolio_item'

module.exports = class WallController extends SiteController
  create: ->
    projectsFetch = Projects.fetchAll()
    @view = @renderReactComponent WallCreateView, region: 'main', model: Projects::projects, changeOptions: 'complete'
    @subscribeEvent 'createwall', @createWall
    projectsFetch.then => @markFinished()

  splash: ->
    prefs = new Preferences()
    prefs.clientMetricsParent = this
    projects = new Projects()
    projects.clientMetricsParent = this
    @view = @renderReactComponent WallSplashView, region: 'main', model: projects
    @subscribeEvent 'selectProject', @onSelectProject
    @subscribeEvent 'showCreateWall', @showCreateWallPage

    prefs.fetchWallPrefs().then =>
      queryString = utils.createQueryFromCollection(prefs, 'ObjectID', 'OR', (pref) ->
        prefName = pref.get('Name')
        prefName.substring(prefName.indexOf('.') + 1)
      )

      projects.fetchAllPages(
        data:
          fetch: 'Name'
          query: queryString
      ).then => @markFinished()

  show: (project) ->
    @updateTitle "Enterprise Backlog for ..."

    PortfolioItemModelFactory.getCollection(1).then (initiativesModel) =>
      @initiatives = new initiativesModel()
      @initiatives.clientMetricsParent = this
      @initiatives.comparator = 'DragAndDropRank'

      PortfolioItemModelFactory.getCollection(0).then (@featuresModel) =>
        @features = new @featuresModel()
        @features.clientMetricsParent = this

        @userStories = new UserStories()
        @userStories.clientMetricsParent = this

        @view = @renderReactComponent WallView, showLoadingIndicator: true, model: @initiatives, region: 'main'
        @subscribeEvent 'cardclick', @onCardClick
        @subscribeEvent 'headerclick', @onHeaderClick
        
        prefs = new Preferences()
        prefs.clientMetricsParent = this
        prefFetch = prefs.fetchWallPref(project)

        @whenProjectIsLoaded project: project, showLoadingIndicator: false, fn: =>

          $.when(prefFetch).then =>
            if !prefs.length
              @initiatives.trigger('add')
              @markFinished()

            pref = prefs.first()
            chosenStates = @_getChosenStates(pref)
            @updateTitle "Enterprise Backlog for #{app.session.getProjectName()}"
            projectRef = "/project/#{project}"#334329159'#12271

            @fetchInitiatives(projectRef, chosenStates).then =>
              if @initiatives.isEmpty()
                @initiatives.trigger('add')
                @markFinished()
              else
                @initiatives.each (initiative) =>
                  initiative.features = new @featuresModel()
                  initiative.features.comparator = 'DragAndDropRank'

                @fetchFeatures(projectRef, @initiatives).then =>
                  @features.each @_addFeatureToItsInitiative, this
                  
                  @initiatives.trigger('add')

                  @fetchUserStories(projectRef, @features).then =>
                    @userStories.each @_addStoryToItsFeature, this

                    @initiatives.trigger('add')
                    if appConfig.isProd()
                      @listenForRealtimeUpdates(project: app.session.get('project'), @_onRealtimeMessage, this)
                    @markFinished()

  fetchInitiatives: (projectRef, chosenStates) ->
    statesQuery = utils.createQueryFromCollection(chosenStates, 'State.Name', 'OR', (item) ->
      "\"#{item}\""
    )
    @initiativeFetchData = 
      data:
        fetch: 'FormattedID,Name,DragAndDropRank'
        query: statesQuery
        order: 'Rank ASC'
        project: projectRef
        projectScopeUp: false
        projectScopeDown: true
    @initiatives.fetchAllPages @initiativeFetchData

  fetchFeatures: (projectRef) ->
    parentsQuery = utils.createQueryFromCollection(@initiatives, 'Parent', 'OR', (item) ->
      "\"#{item.get('_ref')}\""
    )
    @featureFetchData =
      data:
        shallowFetch: 'Parent,FormattedID,DragAndDropRank',
        query: parentsQuery,
        order: 'Rank ASC'
        project: projectRef
        projectScopeUp: false
        projectScopeDown: true

    @features.fetchAllPages @featureFetchData

  fetchUserStories: (projectRef) ->
    parentsQuery = utils.createQueryFromCollection(@features, 'PortfolioItem', 'OR', (item) ->
      "\"#{item.get('_ref')}\""
    )
    @userStoryFetchData =
      data: 
        shallowFetch: 'Release,Iteration,PortfolioItem,ScheduleState,DragAndDropRank',
        query: parentsQuery,
        order: 'Rank ASC'
        project: projectRef
        projectScopeUp: false
        projectScopeDown: true

    @userStories.fetchAllPages @userStoryFetchData

  onSelectProject: (projectRef) ->
    @redirectTo "/wall/#{utils.getOidFromRef(projectRef)}"

  onCardClick: (view, model) ->
    @redirectTo utils.getDetailHash(model)

  onHeaderClick: (view, model) ->
    @redirectTo utils.getDetailHash(model)

  showCreateWallPage: ->
    @redirectTo "/wall/create"

  createWall: (wallInfo) ->
    prefs = new Preferences()
    prefs.clientMetricsParent = this
    user = app.session.get('user')
    prefs.updateWallPreference(user, wallInfo).then =>
      @redirectTo "/wall/#{utils.getOidFromRef(wallInfo.project.get('_ref'))}"

  _getChosenStates: (pref) ->
    JSON.parse(pref.get('Value')).chosenStates

  _addFeatureToItsInitiative: (feature) =>
    parentRef = feature.get('Parent')._refObjectUUID
    initiative = @initiatives.find _.isAttributeEqual('_refObjectUUID', parentRef)

    if initiative?
      initiative.features.add feature
      feature.userStories = new UserStories()
      feature.userStories.comparator = 'DragAndDropRank'

  _addStoryToItsFeature: (story) ->
    parentRef = story.get('PortfolioItem')?._refObjectUUID
    if parentRef
      feature = @features.find _.isAttributeEqual('_refObjectUUID', parentRef)

    if feature?
      feature.userStories.add story

  _onRealtimeMessage: (msgData) ->
    model = if msgData.action == 'Created'
      @_createModelFromRealtimeMessage(msgData)
    else
      @_findModel msgData
      
    if model
      @_updateModelOnPage(model, msgData)

  _findModel: (msgData) ->
    uuid = msgData.id
    
    @initiatives.find(_.isAttributeEqual('_refObjectUUID', uuid)) ||
      @features.find(_.isAttributeEqual('_refObjectUUID', uuid)) ||
      @userStories.find(_.isAttributeEqual('_refObjectUUID', uuid))

  _createModelFromRealtimeMessage: (msgData) ->
    model = switch msgData.modelType.toLowerCase()
      when 'userstory'
        us = new UserStory(_refObjectUUID: msgData.id)
        @userStories.add(us)
        us
      when @features.typePath
        pi = new PortfolioItem(_refObjectUUID: msgData.id)
        pi.typePath = @features.typePath
        @features.add(pi)
        pi
      when @initiatives.typePath
        pi = new PortfolioItem(_refObjectUUID: msgData.id)
        pi.typePath = @initiatives.typePath
        @initiatives.add(pi)
        pi
      else
        null
    
  _updateModelOnPage: (model, msgData, isCreate = false) ->
    fetchData = switch model.typePath
      when @userStories.typePath then @userStoryFetchData
      when @features.typePath then @featureFetchData
      when @initiatives.typePath then @initiativeFetchData
    
    oldParent = !isCreate && @_getParent(model)

    # Use commented code once realtime service supports Iteration, Release, Parent, PortfolioItem fields
    # model.set msgData.state
    # @initiatives.trigger('add')

    model.fetch(fetchData).then =>
      newParent = @_getParent(model)
      if oldParent?._refObjectUUID != newParent?._refObjectUUID
        @_removeFromParentCollection(model, oldParent)
        @_addToParentCollection(model, newParent)

      parentCollection = @_findParentCollection(newParent)
      if parentCollection
        parentCollection.sort()
      @initiatives.trigger('add')

  _addToParentCollection: (model, parentData) ->
    parentCollection = @_findParentCollection(parentData)
    if parentCollection
      parentCollection.add(model)

    parentCollection

  _removeFromParentCollection: (model, parentData) ->
    parentCollection = @_findParentCollection(parentData)
    if parentCollection
      parentCollection.remove(model)

    parentCollection

  _findParentCollection: (parentData) ->
    id = parentData?._refObjectUUID
    return null unless id
    parentModel = @initiatives.find _.isAttributeEqual('_refObjectUUID', id)
    parentModel ?= @features.find _.isAttributeEqual('_refObjectUUID', id)
    parentModel?.features || parentModel?.userStories

  _getParent: (model) ->
    model.get('Parent') || model.get('PortfolioItem')