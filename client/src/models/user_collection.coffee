define ['models/collection', 'models/user'], (Collection, User) ->

  class UserCollection extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/users'
    model: User