define ->
  app = require 'application'
  utils = require 'lib/utils'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  AssociationsView = require 'views/associations/associations'
  
  associationClasses =
    Defects: require 'collections/defects'
    Tasks: require 'collections/tasks'

  class AssociationsController extends SiteController
    defectsForStory: (params) ->
      @_createAssociationView(params.id, 'Defects', 'Requirement')

    tasksForStory: (params) ->
      @_createAssociationView(params.id, 'Tasks', 'WorkProduct')

    _createAssociationView: (id, association, reverseAssociation) ->
      model = new UserStory(ObjectID: id, _type: 'hierarchicalrequirement')
      associatedItems = new associationClasses[association]()

      @whenLoggedIn ->
        
        @_fetchAssociation model, associatedItems, association, reverseAssociation

        @view = @renderReactComponent AssociationsView
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
