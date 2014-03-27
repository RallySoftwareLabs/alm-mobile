/** @jsx React.DOM */
var $ = require('jquery');
var React = require('react');
var ReactView = require('views/base/react_view');
var Spinner = require('spin');

module.exports = ReactView.createBackboneClass({
  getDefaultProps: function() {
    return {
      text: 'Loading'
    };
  },
  render: function() {
    return <div className="jumbotron"><p className="text-center">{ this.props.text }...</p></div>;
  },
  componentDidMount: function() {
    $(this.getDOMNode()).find('p').append(new Spinner().spin().el);
  },
  componentWillUnmount: function() {
    $(this.getDOMNode()).find('.spinner').remove();
  }
});
