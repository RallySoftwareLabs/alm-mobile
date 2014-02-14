define ->
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  View = require 'views/detail/portfolio_item'
  PortfolioItem = require 'models/portfolio_item'

  class PortfolioItemDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (id) ->
      @whenLoggedIn ->
        @fetchModelAndShowView PortfolioItem, View, id

    create: ->
      @whenLoggedIn ->
        @showCreateView PortfolioItem, View

    getFieldNames: ->
      [
        'Blocked',
        'Children'
        'Description',
        'Discussion',
        'FormattedID',
        'Name',
        'Owner',
        'Parent',
        'Ready'
      ]