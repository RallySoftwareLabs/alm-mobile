define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  CollectionView = require 'views/base/collection_view'
  View = require 'views/base/view'

  class ListView extends CollectionView

    className: "list-group"

    initialize: (options) ->
      super

    initItemView: (model) ->
      view = new View {
        model
        autoRender: false
        tagName: 'li'
        className: 'list-group-item'
      }
      type = Handlebars.helpers.typeForDetailLink(model.get('_type'))
      view.template = hbs["listing/templates/#{type}"]
      view
