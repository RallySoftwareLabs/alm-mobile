define ->
  app = require 'application'
  utils = require 'lib/utils'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  AssociationsView = require 'views/associations/associations_view'
  
  associationClasses = {}
  associationClasses.Defects = require 'collections/defects'
  associationClasses.Tasks = require 'collections/tasks'

  class AssociationsController extends SiteController
    defectsForStory: (params) ->
      @_createAssociationView(params.id, 'Defects', 'Requirement')

    tasksForStory: (params) ->
      @_createAssociationView(params.id, 'Tasks', 'WorkProduct')

    _createAssociationView: (id, association, reverseAssociation) ->
      model = new UserStory(ObjectID: id)
      @whenLoggedIn ->
        @view = new AssociationsView
          region: 'main'
          autoRender: true
          collection: new associationClasses[association]()
          association: association
          fromModel: model

        @listenTo @view, 'itemclick', @onItemClick

        @_fetchAssociation model, association, reverseAssociation

    onItemClick: (url) ->
      @redirectTo url

    _fetchAssociation: (model, association, reverseAssociation) ->
      model.fetch
        data:
          fetch: 'ObjectID,FormattedID'
        success: (model, response, opts) =>
          @updateTitle "#{association} for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          @view.collection.fetch
            data:
              fetch: 'ObjectID,FormattedID,Name,Ready,Blocked,ToDo,ScheduleState,State'
              query: "(#{reverseAssociation} = \"#{model.get('_ref')}\")"
              order: 'ObjectID ASC'
            success: (collection, response, options) =>
              if collection.length == 0
                @view.displayNoData()
