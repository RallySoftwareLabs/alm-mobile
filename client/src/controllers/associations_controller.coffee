define ->
  app = require 'application'
  utils = require 'lib/utils'
  Defects = require 'collections/defects'
  PortfolioItems = require 'collections/portfolio_items'
  Tasks = require 'collections/tasks'
  UserStories = require 'collections/user_stories'
  Defect = require 'models/defect'
  PortfolioItem = require 'models/portfolio_item'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  AssociationsView = require 'views/associations/associations'
  
  associationClasses =
    Defects: Defects
    Tasks: Tasks
    Children: UserStories
    UserStories: UserStories

  class AssociationsController extends SiteController
    childrenForStory: (id) ->
      @_createAssociationView(new UserStory(ObjectID: id, _type: 'hierarchicalrequirement'), 'Children', 'Parent')

    defectsForStory: (id) ->
      @_createAssociationView(new UserStory(ObjectID: id, _type: 'hierarchicalrequirement'), 'Defects', 'Requirement')

    tasksForStory: (id) ->
      @_createAssociationView(new UserStory(ObjectID: id, _type: 'hierarchicalrequirement'), 'Tasks', 'WorkProduct')

    tasksForDefect: (id) ->
      @_createAssociationView(new Defect(ObjectID: id, _type: 'defect'), 'Tasks', 'WorkProduct')

    userStoriesForPortfolioItem: (id) ->
      @_createAssociationView(new PortfolioItem(ObjectID: id, _type: 'portfolioitem'), 'UserStories', 'PortfolioItem')

    childrenForPortfolioItem: (id) ->
      @_createAssociationView(new PortfolioItem(ObjectID: id, _type: 'portfolioitem'), 'Children', 'Parent')

    _createAssociationView: (model, association, reverseAssociation) ->
      associatedItems = @_getAssociatedCollection(model, association)

      @whenProjectIsLoaded ->
        
        @_fetchAssociation model, associatedItems, association, reverseAssociation

        @view = @renderReactComponent AssociationsView,
          region: 'main'
          associatedItems: associatedItems
          association: association
          fromModel: model

    _fetchAssociation: (model, associatedItems, association, reverseAssociation) ->
      model.clientMetricsParent = this
      model.fetch
        data:
          fetch: 'FormattedID'
        success: (model, response, opts) =>
          @updateTitle "#{association} for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          associatedItems.fetch
            data:
              shallowFetch: "Blocked,FormattedID,Name,Ready,ScheduleState,State,ToDo"
              query: "(#{reverseAssociation} = \"#{model.get('_ref')}\")"
              order: 'Rank ASC'
            success: =>
              @markFinished()

    _getAssociatedCollection: (model, association) ->
      if (model.get('_type') == 'portfolioitem' && association == 'Children')
        cls = PortfolioItems
      else
        cls = associationClasses[association]

      coll = new cls()
      coll.clientMetricsParent = this
      coll
      
