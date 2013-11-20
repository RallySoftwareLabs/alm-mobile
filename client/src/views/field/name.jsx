/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		FieldMixin = require('views/field/field_mixin');

  return ReactView.createChaplinClass({
  	mixins: [FieldMixin],
    getDefaultProps: function() {
      return {
        editMode: false,
        field: 'Name'
      };
    },
    getInitialState: function() {
      return {
        editMode: this.props.editMode
      };
    },
  	render: function() {
      if (this.state.editMode) {
        return <div className="edit"><div class="header">{ this.getInputMarkup() }</div></div>;
      }
  		return <div className="display"><div className="header" onClick={ this._onClick }>{ this.getFieldValue() }</div></div>;
  	},

    _onClick: function(e) {
      this.setState({editMode: true});
    }
  });
});