define ['collections/collection', 'models/user_story'], (Collection, UserStory) ->

  Collection.extend(
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirements'
    model: UserStory
  )