SiteController = require 'controllers/base/site_controller'
IterationView = require 'views/detail/iteration'

module.exports = class IterationController extends SiteController

  show: (id) ->
    @whenProjectIsLoaded().then =>
      @renderReactComponent(IterationView, region: 'main', iterationId: id)