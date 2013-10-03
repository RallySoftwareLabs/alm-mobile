define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  ListPageView = require 'views/listing/list_page_view'

  class AssociationsView extends ListPageView
    template: hbs['associations/templates/association']

    initialize: (options) ->
      super
      @association = options.association

    getTemplateData: ->
      data = super
      data.association = @association
      data.iconCls = @_getIconCls()
      data

    displayNoData: ->
      @$('.no-data').show()

    _getIconCls: ->
      'icon-' + @association.toLowerCase().slice(0, @association.length - 1)
