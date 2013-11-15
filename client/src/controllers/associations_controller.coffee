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

  class AssociationsController extends SiteController
    defectsForStory: (params) ->
      @_createAssociationView(new UserStory(ObjectID: params.id, _type: 'hierarchicalrequirement'), 'Defects', 'Requirement')

    tasksForStory: (params) ->
      @_createAssociationView(new UserStory(ObjectID: params.id, _type: 'hierarchicalrequirement'), 'Tasks', 'WorkProduct')

    tasksForDefect: (params) ->
      @_createAssociationView(new Defect(ObjectID: params.id, _type: 'defect'), 'Tasks', 'WorkProduct')

    _createAssociationView: (model, association, reverseAssociation) ->
      associatedItems = new associationClasses[association]()

      @whenLoggedIn ->
        
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
              fetch: 'ObjectID,FormattedID,Name,Ready,Blocked,ToDo,ScheduleState,State'
              query: "(#{reverseAssociation} = \"#{model.get('_ref')}\")"
              order: 'ObjectID ASC'
