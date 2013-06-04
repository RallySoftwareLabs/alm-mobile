define [
  'hbsTemplate'
  'application'
  'views/base/collection_view'
  'views/home/defect_view'
], (hbs, app, CollectionView, DefectView) ->

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
