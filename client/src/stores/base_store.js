var Backbone = require('backbone');
var _ = require('lodash');

var BaseStore = {};
  
_.extend(BaseStore, Backbone.Events);

module.exports = BaseStore;
