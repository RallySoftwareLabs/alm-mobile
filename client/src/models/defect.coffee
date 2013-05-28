define ['models/model'], (Model) ->

  Model.extend
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defects'

    defaults: {
      "State" : "Open"
    }