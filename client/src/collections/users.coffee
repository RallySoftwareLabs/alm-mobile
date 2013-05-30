define ['collections/collection', 'models/user'], (Collection, User) ->

  class Users extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/users'
    model: User