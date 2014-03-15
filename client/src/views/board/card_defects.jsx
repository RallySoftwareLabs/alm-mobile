/** @jsx React.DOM */
define(function() {
  var _ = require('underscore');
  var React = require('react');
  var ReactView = require('views/base/react_view');
  var app = require('application');
  var utils = require('lib/utils');

  return ReactView.createBackboneClass({
    render: function() {
      var m = this.props.model;
      var activeDefectCount = this._getActiveDefectCount();
      var defectsMarkup;

      if (this._getActiveDefectCount() > 0) {
        defectsMarkup = <span><span className="count">{ activeDefectCount }</span><span> active</span></span>;
      } else {
        defectsMarkup = <span dangerouslySetInnerHTML={{__html: '&nbsp;'}}/>
      }
      if (this._hasDefects()) {
        return (
          <div className="status-value defects"
               title="Manage Defects"
               onClick={ this._onClick }
               role="link"
               aria-label={ "This item has " + activeDefectCount + " active defects. Click to view or edit all defects for this item." }>
              <div className={ "status-icon " + m.get('DefectStatus') }></div>
              { defectsMarkup }
          </div>
        );
      }
      return <div/>;
    },

    _onClick: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked card defects'});
      this.routeTo(utils.getDetailHash(this.props.model) + '/defects');
      e.preventDefault();
    },

    _hasDefects: function() {
      var m = this.props.model;
      return m.get('Summary') && m.get('Summary').Defects && m.get('Summary').Defects.Count > 0;
    },

    _getActiveDefectCount: function() {
      var m = this.props.model;
      var activeDefectCount = 0;
      if (m.get('Summary').Defects.State) {
        _.each(m.get('Summary').Defects.State, function(val, key) {
          if (key !== 'Closed') {
            activeDefectCount += val;
          }
        });
      }

      return activeDefectCount;
    }
  });
});
