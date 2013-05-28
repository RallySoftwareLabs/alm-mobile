define ['models/collection', 'models/task'], (Collection, Task) ->

  Collection.extend
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/tasks'
    model: Task