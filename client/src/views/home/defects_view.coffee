define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  CollectionView = require 'views/base/collection_view'
  DefectView = require 'views/home/defect_view'

  class UserStoriesView extends CollectionView

    className: "btn-group btn-group-vertical"
    itemView: DefectView

    events:
      'click #add-defect' : 'addDefect'

    getTemplateData: ->
      # error: @options.error
      defects: @model.toJSON()

    addDefect: ->
      @publishEvent '!router:routeByName', 'defect_detail#create', replace: true
