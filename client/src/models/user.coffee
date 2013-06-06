define [
  'models/base/model'
], (Model) ->

  class User extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/user'