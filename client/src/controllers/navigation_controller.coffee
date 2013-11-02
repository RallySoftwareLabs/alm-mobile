define ->
  app = require 'application'
  utils = require 'lib/utils'
  React = require 'react'
  Controller = require 'controllers/base/controller'
  NavigationView = require 'views/navigation/navigation_view'

  class NavigationController extends Controller

    constructor: ->
      super
      # @view = React.renderComponent(NavigationView({}), document.getElementById('navigation'))
      @view = new NavigationView region: 'navigation', autoRender: true
      @listenTo @view, 'navigate', @onNavigate

    onNavigate: (newRoute) ->
      @view.hide()
      currentRoute = window.location.pathname

      unless newRoute == currentRoute || (newRoute == '' && _.contains(['/userstories', '/tasks', '/defects'], currentRoute))
        @redirectTo newRoute
