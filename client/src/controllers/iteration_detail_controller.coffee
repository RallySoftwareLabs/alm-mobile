SiteController = require 'controllers/base/site_controller'
IterationView = require 'views/detail/iteration'

module.exports = class IterationController extends SiteController

  show: (id) ->
    @whenProjectIsLoaded =>
      @renderReactComponent(IterationView, region: 'main', iterationId: id)