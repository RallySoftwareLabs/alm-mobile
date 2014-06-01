var _ = require('underscore');
var Markdown = require('pagedown');
var md = require('html-md');
var appConfig = require('app_config');

var NAVIGATION_MODEL_TYPES = {
  'hierarchicalrequirement': 'userstory'
};

WSAPI_MODEL_TYPES = {};
_.each(NAVIGATION_MODEL_TYPES, function(value, key) {
  WSAPI_MODEL_TYPES[value] = key;
});

var toBeReplaced = /[\\s_\\.]/g;
var toBeRemoved = /[\\+]/g;

_.mixin({
  capitalize: function(string) {
    var s = string || '';
    return s.charAt(0).toUpperCase() + s.substring(1).toLowerCase();
  },
  singularize: function(string) {
    var s = string || '';
    if (s === 'Children') {
      return 'Child';
    } else if (s === 'UserStories') {
      return 'User Story';
    }
    return s.slice(0, -1);
  },
  getAttribute: function(attr) {
    return function(model) { return model.get(attr); };
  },
  isAttributeEqual: function(attr, value) {
    return function(model) { return model.get(attr) === value; };
  },
  areAttributesEqual: function(attrs) {
    return function(model) {
      return _.every(attrs, function(value, attr) {
        return model.get(attr) === value;
      });
    };
  }
});

module.exports = {
  getDetailHash: function(model) {
    var attributes = model.attributes || model;
    return this._getNavigationType(this.getTypeFromRef(attributes._ref).split('/')[0]) + '/' + attributes._refObjectUUID;
  },

  getWsapiType: function(type) {
    var t = (type || '').toLowerCase();
    return WSAPI_MODEL_TYPES[t] || t;
  },

  getRef: function(type, id) {
    return '/' + this.getWsapiType(type) + '/' + id;
  },

  getOidFromRef: function(ref) {
    ref = ref._ref || ref;
    return ref.substr(ref.lastIndexOf("/") + 1);
  },

  getTypeFromRef: function(ref) {
    if (!ref) return '';
    var parts = ref.split('/');
    var piIndex = _.indexOf(parts, 'portfolioitem');
    if (piIndex > -1) {
      return parts.slice(piIndex, piIndex + 2).join('/');
    }
    return parts[parts.length - 2];
  },

  toRelativeRef: function(ref) {
    ref = ref || '';
    var prefix = appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION';
    return (ref.indexOf(prefix) === -1) ? ref : ref.substring(prefix.length);
  },

  getProfileImageUrl: function(ref, size) {
    if (!ref) return '';
    var baseUrl = appConfig.almWebServiceBaseUrl;
    return baseUrl + '/profile/image/' + this.getOidFromRef(ref) + '/' + (size || '25') + '.sp';
  },

  /*
   * Maps a collection to a Rally ALM WSAPI query string.
   *
   * this.param {Collection} collection - The collection to convert to a query
   * this.param {String} property - Which field to use as the property of the filter
   * this.param {String} joinType - To AND or OR all the values
   * this.param {Function} itemValueFn - A function to map each item in the collection to its value to filter on
   * this.public
   */
  createQueryFromCollection: function(collection, property, joinType, itemValueFn) {
    return collection.reduce(function(result, item) {
      var value = itemValueFn(item);
      var queryParam = '(' + property + ' = ' + value + ')';

      return result ? '(' + result + ' ' + joinType + ' ' + queryParam + ')' : queryParam;
    }, '');
  },

  toCssClass: function(value) {
    var str = value.toLowerCase().replace(toBeRemoved, '').trim().replace(toBeReplaced, '-');
    return str.replace(/&nbsp;/g, '-').replace(/[^\w\-]/g, '-');
  },

  getTypeForDetailLink: function(value) {
    var str = (value || '').toLowerCase();
    if (str === 'hierarchicalrequirement') {
      str = 'userstory';
    } else if (_.contains(str, 'portfolioitem')) {
      str = 'portfolioitem';
    }
    return str;
  },

  fixImageSrcs: function(html) {
    return html && html.replace(/src=\"\/slm/g, 'src="' + appConfig.almWebServiceBaseUrl);
  },

  toMarkdown: function(html) {
    return new Markdown.Converter().makeHtml(html || '').replace(/(\r\n|\n|\r)/gm,"");
  },

  md: function(str) {
    return md(str || '');
  },

  _getNavigationType: function(type) {
    type = type.toLowerCase();
    return NAVIGATION_MODEL_TYPES[type] || type;
  },
};