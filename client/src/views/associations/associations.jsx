/** @jsx React.DOM */
define(function() {
  var _ = require('underscore'),
      React = require('react'),
      utils = require('lib/utils'),
      ReactView = require('views/base/react_view'),
      ListView = require('views/listing/list');

  return ReactView.createChaplinClass({
    render: function() {
      var association = this.props.association;
      return (
        <div className="artifact-association">
          <h4>
            <span class={this._getIconCls()}/>
            {association}
            <button className="btn btn-primary add-button" onClick={ this._onAddClick }>+ Add { _.singularize(association) }</button>
          </h4>
          <div class="listing">
            <ListView
              model={this.props.associatedItems}
              noDataMsg={"This " + utils.getTypeForDetailLink(this.props.fromModel.get('_type')) + " has no " + association.toLowerCase()}
              showLoadingIndicator={true}
              changeOptions="synced"/>
          </div>
        </div>
      );
    },

    _getIconCls: function() {
      var association = this.props.association;
      return 'picto icon-' + association.toLowerCase().slice(0, association.length - 1);
    },

    _onAddClick: function() {
      this.publishEvent('!router:route', Backbone.history.fragment + '/new');
    }
  });
});