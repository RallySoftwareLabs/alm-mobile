define ['collections/collection', 'models/defect'], (Collection, Defect) ->

  Collection.extend
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defects'
    model: Defect