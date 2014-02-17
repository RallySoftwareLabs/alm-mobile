define ->
  app = require 'application'
  utils = require 'lib/utils'
  Defect = require 'models/defect'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  AssociationsView = require 'views/associations/associations'
  
  associationClasses =
    Defects: require 'collections/defects'
    Tasks: require 'collections/tasks'
    Children: require 'collections/user_stories'

  class AssociationsController extends SiteController
    childrenForStory: (id) ->
      @_createAssociationView(new UserStory(ObjectID: id, _type: 'hierarchicalrequirement'), 'Children', 'Parent')

    defectsForStory: (id) ->
      @_createAssociationView(new UserStory(ObjectID: id, _type: 'hierarchicalrequirement'), 'Defects', 'Requirement')

    tasksForStory: (id) ->
      @_createAssociationView(new UserStory(ObjectID: id, _type: 'hierarchicalrequirement'), 'Tasks', 'WorkProduct')

    tasksForDefect: (id) ->
      @_createAssociationView(new Defect(ObjectID: id, _type: 'defect'), 'Tasks', 'WorkProduct')

    _createAssociationView: (model, association, reverseAssociation) ->
      associatedItems = new associationClasses[association]()

      @whenProjectIsLoaded ->
        
        @_fetchAssociation model, associatedItems, association, reverseAssociation

        @view = @renderReactComponent AssociationsView,
          region: 'main'
          associatedItems: associatedItems
          association: association
          fromModel: model

    _fetchAssociation: (model, associatedItems, association, reverseAssociation) ->
      model.fetch
        data:
          fetch: 'ObjectID,FormattedID'
        success: (model, response, opts) =>
          @updateTitle "#{association} for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          associatedItems.fetch
            data:
              fetch: 'Blocked,FormattedID,Name,ObjectID,Parent,Ready,ScheduleState,State,ToDo'
              query: "(Parent = \"#{model.get('_ref')}\")"
              order: 'ObjectID ASC'
            success: =>
              @markFinished()
