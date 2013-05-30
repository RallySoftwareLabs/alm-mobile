define ['collections/collection', 'models/project'], (Collection, Project) ->

  class Projects extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/project'
    model: Project
