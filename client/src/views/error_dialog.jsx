/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view');

  return ReactView.createBackboneClass({
    getInitialState: function() {
      return { errors: [] };
    },
    render: function() {
      var errorItems = (this.state.errors).map(function(item) {
            return <li key={ item }>{ item }</li>;
          }, this);
      return (
        <div className={ "save-failure modal" + (this._hasErrors() ? '' : ' hidden') } tabIndex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 className="modal-title" id="myModalLabel">An Error Occurred saving your changes</h4>
              </div>
              <div className="modal-body">
                <ul>
                  { errorItems }
                </ul>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-primary" data-dismiss="modal" onClick={ this._onDismiss }>OK</button>
              </div>
            </div>
          </div>
        </div>
      );
    },

    componentWillMount: function() {
      this.subscribeEvent('showerrors', this._onShowErrors);
    },
    
    componentDidUpdate: function() {
      var saveFailure = $('.save-failure');
      if (this._hasErrors()) {
        saveFailure.modal('show');
      } else {
        saveFailure.modal('hide');
      }
    },

    _onShowErrors: function(errors) {
      this.setState({ errors: errors });
    },

    _onDismiss: function() {
      this.setState(this.getInitialState());
    },

    _hasErrors: function() {
      return this.state.errors.length;
    }
  });
});