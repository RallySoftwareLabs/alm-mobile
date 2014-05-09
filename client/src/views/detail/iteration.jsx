/** @jsx React.DOM */
var React = require('react');
var moment = require('moment');
var ReactView = require('views/base/react_view');
var DetailMixin = require('views/detail/detail_mixin');
var PlanStatusMixin = require ('lib/plan_status_mixin');
var IterationStore = require('stores/iteration_store');
var ListView = require('views/listing/list');
var TitledWellView = require('views/field/titled_well');

module.exports = ReactView.createBackboneClass({
  mixins: [PlanStatusMixin, DetailMixin],
  getInitialState: function() {
    var store = new IterationStore({
      iterationId: this.props.iterationId
    });
    return {
      store: store
    };
  },
  componentDidMount: function() {
    this.listenTo(this.state.store, 'change', this.forceUpdate);
    this.listenTo(this.state.store, 'error', this.showError);
    this.subscribeEvent('saveField', this.state.store.saveField.bind(this.state.store));
    this.state.store.load();
  },
  render: function() {
    var iteration = this.state.store.getModel();
    var scheduledItems = this.state.store.getScheduledItems();
    var loadStatus = this.loadStatus(iteration);
    var loadPercentage = this.loadPercentage(iteration);
    var scheduledPoints = scheduledItems ? scheduledItems.reduce(function(acc, us) {
      return acc + (us.get('PlanEstimate') || 0);
    }, 0) : 0;
    return (
      <div className={"detail-view iteration " + loadStatus} autoFocus="autofocus">
        <div>
          <div className="name text-center">
            {
              iteration.get('Name') + " (" +
              moment(iteration.get('StartDate')).format('MMM D') + " to " + moment(iteration.get('EndDate')).format('MMM D')
              + ")"
            }
          </div>
          <div className="load-status text-center">{loadStatus}</div>
          <div className="row">
            <div className="col-xs-4">
              <div className="well-title control-label" aria-hidden="true">Scheduled</div>
              <div className="well well-sm titled-well-sm"
                   tabIndex="0"
                   aria-label={ scheduledPoints + " points scheduled"}>
                { scheduledPoints }
              </div>
            </div>
            <div className="col-xs-4">
              <TitledWellView item={ iteration } field='PlannedVelocity' label='Velocity' inputType='number'/>
            </div>
            <div className="col-xs-4">
              <div className="well-title control-label" aria-hidden="true">Load</div>
              <div className="well well-sm titled-well-sm"
                   tabIndex="0"
                   aria-label={ loadPercentage + "% loaded"}>
                <div className="meter-container">
                  <div className="bar">
                    <div className={ "meter " + loadStatus} style={{ width: Math.min(100, loadPercentage) + "%" }}></div>
                    <div className="percent">{ loadPercentage + "%" }</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="well-title control-label" aria-hidden="true">Scheduled Items</div>
        { scheduledItems ? <ListView model={ scheduledItems }/> : '' }
        { this._getFeaturesMarkup() }
      </div>
    );
  },

  _getFeaturesMarkup: function() {
    var features = this.state.store.getFeatures();
    if (features.length) {
      return (
        <div>
          <div className="well-title control-label" aria-hidden="true">Working Towards</div>
          <ListView model={ features }/>
        </div>
      );
    }
    return '';
  }
});
