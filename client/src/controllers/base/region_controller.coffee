$ = require 'jquery'
Controller = require 'controllers/base/controller'

module.exports = class RegionController extends Controller

  _getView: (props, id) ->
    target = (if id then document.getElementById(id) else document.body)
    React.renderComponent @view(props), target

  renderReactComponent: (componentClass, props = {}, id) ->
    regions = @renderReactComponents([
      view: componentClass
      region: props.region
      props: _.omit(props, 'region')
    ])
    regions[props.region]

  renderReactComponents: (components) ->
    props = _.transform components, (p, cmp) =>
      p[cmp.region] = view: cmp.view, props: _.defaults(ref: cmp.region, cmp.props)
    , {}
    
    containerViewInstance = @_getView(props)
    _.pick(containerViewInstance.refs, _.pluck(components, 'region'))
