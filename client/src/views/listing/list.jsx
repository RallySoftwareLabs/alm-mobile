/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var utils = require('lib/utils');
  var ReactView = require('views/base/react_view');

  return ReactView.createChaplinClass({
    render: function() {
      var model = this.props.model;
      if (model.isSynced()) {
        if (model.length) {
          var listItems = model.map(function(item) {
            return (
              <li className="list-group-item" key={item.get('ObjectID')}>
                {this._getItemMarkup(item)}
              </li>
            );
          }, this);
          return <ul className="list-group">{listItems}</ul>;
        } else {
          return (
            <div className="well no-data">{this.props.noDataMsg}</div>
          );
        }
      } else {
        return <div/>
      }
    },

    _getItemMarkup: function(model) {
      return this['_' + utils.getTypeForDetailLink(model.get('_type')) + 'ItemMarkup'](model);
    },

    _userstoryItemMarkup: function(model) {
      return (
        <div className="row" id={model.get('ObjectID')} onClick={this._goToItemPageFn(model)}>
          <div className="col-xs-11 item">
              <div className={this._getStateClassName(model)}></div>
              <div className="item-id-name">
                  <a className="formatted-id">{model.get('FormattedID')}</a>
                  <div className="workitem-name">{model.get('Name')}</div>
              </div>
          </div>
          <div className="col-xs-1 chevron"><i className="picto icon-chevron-right"></i></div>
        </div>
      );
    },

    _defectItemMarkup: function(model) {
      return this._userstoryItemMarkup(model);
    },

    _taskItemMarkup: function(model) {
      var todo;
      if (model.get('ToDo')) {
        todo = (
          <div className="col-xs-2 task-to-do">
              <span className="picto icon-to-do"></span>{model.get('ToDo')}h
          </div>
        );
      } else {
        todo = <div className="col-xs-2 task-to-do"/>;
      }
      return (
        <div className="row" id={model.get('ObjectID')} onClick={this._goToItemPageFn(model)}>
            <div className="col-xs-9 item">
                <div className={this._getStateClassName(model)}></div>
                <div className="item-id-name">
                    <a className="formatted-id">{model.get('FormattedID')}</a>
                    <div className="workitem-name">{model.get('Name')}</div>
                </div>
            </div>
            {todo}
            <div className="col-xs-1 chevron"><i className="picto icon-chevron-right"></i></div>
        </div>
      );
    },

    _goToItemPageFn: function(model) {
      var url = utils.getTypeForDetailLink(model.get('_type')) + '/' + model.get('ObjectID');
      return _.bind(function(event) {
        this.publishEvent('!router:route', url);
        event.preventDefault();
      }, this);
    },

    _getStateClassName: function(model) {
      if (model.get('Blocked')) {
        return 'blocked picto icon-blocked';
      } else if (model.get('Ready')) {
        return 'ready picto icon-ready';
      }
      return '';
    }

  });
});