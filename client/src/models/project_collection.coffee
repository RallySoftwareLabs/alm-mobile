define ['models/collection', 'models/project'], (Collection, Project) ->

  class ProjectCollection extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/project'
    model: Project
