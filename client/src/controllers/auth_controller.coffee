define ->
  app = require 'application'
  Controller = require 'controllers/base/controller'
  Preference = require 'models/preference'
  LabsNoticeView = require 'views/auth/labs_notice'
  LoginView = require 'views/auth/login'

  class AuthController extends Controller

    logout: (params) ->
      app.session.logout()
      @login()

    login: (params) ->
      @view = @renderReactComponent LoginView
      @subscribeEvent 'submit', @onSubmit
      @markFinished()

    labsNotice: (params) ->
      @view = @renderReactComponent LabsNoticeView
      @subscribeEvent 'accept', @onAccept
      @subscribeEvent 'reject', @onReject
      @markFinished()

    onSubmit: (username, password, rememberme) ->
      app.aggregator.recordAction component: this, description: 'logging in'
      app.session.authenticate username, password, (authenticated) =>
        if err?
          app.session.logout()
          @view.showError 'There was an error signing in. Please try again.'
        else
          if authenticated
            @redirectTo app.afterLogin, replace: true
          else
            app.session.logout()
            @view.showError 'The password you have entered is incorrect.'

    onAccept: ->
      app.aggregator.recordAction component: this, description: 'accepted labs notice'
      app.session.acceptLabsNotice().then =>
        @redirectTo app.afterLogin, replace: true

    onReject: ->
      app.aggregator.recordAction component: this, description: 'rejected labs notice'
      @redirectTo 'login'
