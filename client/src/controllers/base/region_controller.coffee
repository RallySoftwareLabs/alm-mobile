$ = require 'jquery'
Controller = require 'controllers/base/controller'

module.exports = class RegionController extends Controller

  _getView: (props, id) ->
    deferred = $.Deferred()
    target = (if id then document.getElementById(id) else document.body)
    containerViewInstance = React.renderComponent @view(props), target, (component) ->
      deferred.resolve()

    $.when(deferred.promise()).then -> containerViewInstance

  renderReactComponent: (componentClass, props = {}, id) ->
    @renderReactComponents([
      view: componentClass
      region: props.region
      props: _.omit(props, 'region')
    ]).then (regions) ->
      regions[props.region]

  renderReactComponents: (components) ->
    props = _.transform components, (p, cmp) =>
      p[cmp.region] = view: cmp.view, props: _.defaults(ref: cmp.region, cmp.props)
    , {}
    
    @_getView(props).then (containerViewInstance) ->
      _.pick(containerViewInstance.refs, _.pluck(components, 'region'))
