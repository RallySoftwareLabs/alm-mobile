/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var utils = require('lib/utils');
  var ReactView = require('views/base/react_view');
  var ListView = require('views/listing/list');
  var IterationHeader = require('views/iteration_header');

  return ReactView.createChaplinClass({
    render: function() {
      return (
        <div id="home-view">
        	<IterationHeader visible={true} />
          <div id="home-view-navigation">
            <ul className="type nav nav-pills nav-justified">
              {this._getTabs()}
            </ul>
          </div>

          <div className="listing">
          	<ListView
          	  model={this.props.collection}
          	  noDataMsg={"There are no " + this.props.tab}
          	  showLoadingIndicator={true}
          	  changeOptions="synced"/>
          </div>

          <ul className="type nav nav-pills nav-justified">
            <li className="active">
              <a href={"new/" + this.props.listType} id="add-artifact"><i className="picto icon-add"/></a>
            </li>
          </ul>
        </div>
      );
    },

    _getTabs: function() {
    	var currentTab = this.props.tab;
      var tabs = [{
        key: 'userstories',
        value: 'Stories',
        active: currentTab === 'userstories'
      }, {
        key: 'tasks',
        value: 'Tasks',
        active: currentTab === 'tasks'
      }, {
        key: 'defects',
        value: 'Defects',
        active: currentTab === 'defects'
      }];
      return _.map(tabs, function(tab) {
      	return (
      		<li className={tab.active ? 'active' : ''} key={tab.key}>
      		  <a href={"/" + tab.key} id={tab.key + "-tab"}>
      		    {tab.value}
      		  </a>
      		</li>
				);
      });
    }
  });
});