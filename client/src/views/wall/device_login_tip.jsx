/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view');
  	
  return ReactView.createBackboneClass({
    render: function() {
      return (  
          <div className="col-md-3 hidden-xs hidden-sm">
            <div className="row">
              <div className="col-md-2 wrapIcon">
                <div className="picto icon-mobile mobileIcon" />
              </div>
              <div className="col-md-10">
                <h3>{this.generateMobileURL()}</h3>
                Access details on your device
              </div>
            </div>
          </div>
      );
     },
     generateMobileURL: function() {
        var port = (location.port != "80") ? ":" + location.port : "";
        return location.hostname + port;
     }
  });
});