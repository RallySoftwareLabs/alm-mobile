/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var utils = require('lib/utils');
  var PlanStatusMixin = require ('lib/plan_status_mixin');
  var ReactView = require('views/base/react_view');

  return ReactView.createBackboneClass({
    mixins: [PlanStatusMixin],
    render: function() {
      var model = this.props.model;
      if (model.isSynced()) {
        if (model.length) {
          var listItems = model.map(function(item) {
            return (
              <li className={'list-group-item ' + this.planStatus(item)} key={item.get('_ref')}>
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
        <div className="row" onClick={this._goToItemPageFn(model)}>
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

    _portfolioitemItemMarkup: function(model) {
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
        <div className="row" onClick={this._goToItemPageFn(model)}>
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

    _conversationpostItemMarkup: function(model) {
      return (
        <div className="discussion-item">
            {this._getDiscussionArtifactMarkup(model)}
            <div className="profile-image">
              <img src={utils.getProfileImageUrl(model.get('User')._ref, 80)}/>
            </div>
            <div className="details">
              <div className="status">
                <span className="profile-link"><span>{model.get('User')._refObjectName}</span></span>
                <span className="recency">{_(model.get('_CreatedAt')).capitalize()}</span>
              </div>
              <div className="detail-text" dangerouslySetInnerHTML={{__html: model.get('Text')}} />
            </div>
        </div>
      );
    },

    _goToItemPageFn: function(model) {
      var url = utils.getDetailHash(model);
      return _.bind(function(event) {
        this.routeTo(url);
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
    },

    _getDiscussionArtifactMarkup: function(model) {
      if (this.props.showItemArtifact) {
        var artifact = model.get('Artifact');
        return (
          <div className="artifact">
              <a className="artifact-link" href={"/" + utils.getTypeForDetailLink(artifact._type) + "/" + utils.getOidFromRef(artifact._ref)}>{artifact.FormattedID}</a>
              <span className="artifact-name">{artifact._refObjectName}</span>
          </div>
        );
      }
      return '';
    }

  });
});