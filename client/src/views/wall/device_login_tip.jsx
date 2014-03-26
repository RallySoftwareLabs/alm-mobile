/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
  
module.exports = ReactView.createBackboneClass({
  render: function() {
    return (  
        <div className="col-md-3 hidden-xs hidden-sm">
          <div className="row">
            <div className="col-md-2 wrap-icon">
              <div className="picto icon-mobile mobile-icon" />
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
