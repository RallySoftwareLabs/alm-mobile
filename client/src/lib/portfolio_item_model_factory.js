var Promise = require('es6-promise').Promise;
var appConfig = require('app_config');
var PortfolioItem = require('models/portfolio_item');
var PortfolioItems = require('collections/portfolio_items');
var TypeDefinitions = require('collections/type_definitions');

module.exports = {
  getCollection: function(ordinal) {
    var me = this;
    return me.fetchTypes().then(function(piTypeDefinitions) {
      var typeDef = me.lookupTypeDef(ordinal, piTypeDefinitions);
      var typePath = typeDef.get('TypePath');
      var model = me._buildModel(typeDef);
      return PortfolioItems.extend({
        url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/' + typePath.toLowerCase(),
        model: model,
        typePath: typePath,
        name: model.prototype.name
      });
    });
  },

  getModel: function(ordinal) {
    var me = this;
    return me.fetchTypes().then(function(piTypeDefinitions) {
      return me._buildModel(me.lookupTypeDef(ordinal, piTypeDefinitions));
    });
  },

  _buildModel: function(typeDef) {
    var typePath = typeDef.get('TypePath');
    return PortfolioItem.extend({
      urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/' + typePath.toLowerCase(),
      typePath: typePath,
      name: typeDef.get('Name')
    });
  },
  
  lookupTypeDef: function(ordinal, typeDefinitions) {
    return typeDefinitions.findWhere({Ordinal: ordinal});
  },

  fetchTypes: function() {
    if (this.piTypeDefinitions) {
      return this.piTypeDefinitions;
    }

    var piTypeDefinitions = new TypeDefinitions();
    this.piTypeDefinitions = piTypeDefinitions.fetchAllPages({
      data: {
        fetch: 'Name,TypePath,Ordinal',
        query: '(Parent.Name = "Portfolio Item")',
        order: 'Ordinal'
      }
    });
    return this.piTypeDefinitions;
  },

  clear: function() {
    this.piTypeDefinitions = null;
  }

};