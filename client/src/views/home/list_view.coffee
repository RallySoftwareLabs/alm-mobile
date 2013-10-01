define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  CollectionView = require 'views/base/collection_view'
  View = require 'views/base/view'

  class ListView extends CollectionView

    className: "list-group"

    initialize: (options) ->
      super
      @listType = options.listType || 'userstory'
      @delegate 'click', "#add-#{@listType}", @addItem

    initItemView: (model) ->
      view = new View {
        model
        autoRender: false
        tagName: 'li'
        className: 'list-group-item'
      }
      view.template = hbs["home/templates/#{@listType}"]
      view

    addItem: ->
      @publishEvent '!router:routeByName', "#{@listType}_detail#create", replace: true
