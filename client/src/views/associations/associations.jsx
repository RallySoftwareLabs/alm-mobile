/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var utils = require('lib/utils');
  var ReactView = require('views/base/react_view');
  var ListView = require('views/listing/list');

  return ReactView.createChaplinClass({
    render: function() {
      var association = this.props.association;
      return (
        <div id="artifact-association">
          <h4>
            <span class={this._getIconCls()}/>
            {association}
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
    }
  });
});