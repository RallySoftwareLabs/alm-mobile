var Promise = require('es6-promise').Promise;
var _ = require('underscore');
var app = require('application');
var utils = require('lib/utils');
var Artifacts = require('collections/artifacts');
var Iteration = require('models/iteration');
var BaseStore = require('stores/base_store');

var DetailStore = Object.create(BaseStore);

_.extend(DetailStore, {

  saveField: function(view, updates, opts) {
    if (this.getModel().get('_ref')) {
      this._saveRemote(view, updates, opts);
    } else {
      this._saveLocal(view, updates, opts);
    }
  },

  saveNew: function(view, model) {
    var me = this;
    model.save(null, {
      shallowFetch: this.getFieldNames().join(','),
      wait: true,
      patch: true,
      success: function(resp, status, xhr) {
        // opts.success(model, resp);
        me.publishEvent('router:changeURL', utils.getDetailHash(model), { replace: true });
        me._setTitle(model);
      },
      error: function(model, resp, options) {
        view.showError(model, resp);
      }
    });
  },

  getModel: function() {
    throw new Error("Need to implement getModel function");
  },

  _getAllowedValuesForFields: function(model) {
    var fieldNames = this.getFieldNames();
    Promise.all(_.map(fieldNames, model.getAllowedValues, model)).then(function(avs) {
      return _.transform(avs, function(result, av, index) {
        result[fieldNames[index]] = av;
      }, {});
    });
  },

  _saveLocal: function(view, updates) {
    this.getModel().set(updates);
  },

  _saveRemote: function(view, updates, opts) {
    var me = this;
    this.getModel().save(updates, {
      shallowFetch: this.getFieldNames(),
      patch: true,
      success: function(model, resp, options) {
        if (opts && _.isFunction(opts.success)) {
          opts.success(model, resp, options);
        }
      },
      error: function(model, resp, options) {
        if (opts && _.isFunction(opts.error)) {
          opts.error(model, resp, options);
          me.trigger('error', model, resp);
        }
      }
    });
    this.trigger('change');
  }
});

module.exports = DetailStore;
