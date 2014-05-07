/** @jsx React.DOM */
var _ = require('underscore');
var React = require('react');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var ListView = require('views/listing/list');

module.exports = ReactView.createBackboneClass({
  render: function() {
    var association = this.props.association;
    return (
      <div className="artifact-association">
        <h4>
          <span className={this._getIconCls()}/>
          {association}
          <button className="btn btn-primary add-button" onClick={ this._onAddClick }>+ Add { _.singularize(association) }</button>
        </h4>
        <ListView
          model={this.props.associatedItems}
          noDataMsg={"This " + utils.getTypeForDetailLink(this.props.fromModel.get('_type')) + " has no " + association.toLowerCase()}
          showLoadingIndicator={true}
          changeOptions="sync"/>
      </div>
    );
  },

  _getIconCls: function() {
    var association = _.singularize(this.props.association);
    if (association === 'User Story') {
      association = 'Story';
    }
    return 'picto icon-' + association.toLowerCase().replace(/\s/g, '-');
  },

  _onAddClick: function() {
    this.routeTo(Backbone.history.fragment + '/new');
  }
});
