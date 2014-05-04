$ = require 'jquery'
Controller = require 'controllers/base/controller'
SiteView = require 'views/site'

siteViewInstance = null

module.exports = class SiteController extends Controller

  _getView: (props, id) ->
    deferred = $.Deferred()
    if siteViewInstance && siteViewInstance.isMounted()
      siteViewInstance.setProps props, ->
        deferred.resolve(siteViewInstance)
    else
      siteView = SiteView(props)
      siteViewInstance = React.renderComponent siteView, (if id then document.getElementById(id) else document.body)
      deferred.resolve(siteViewInstance)

    deferred.promise()

  renderReactComponent: (componentClass, props = {}, id) ->
    viewProps = {}
    viewProps[props.region] = view: componentClass, props: _.defaults(ref: props.region, _.omit(props, 'region'))
    @_getView(viewProps, id).then (siteViewInstance) -> siteViewInstance.refs[props.region]

  renderReactComponents: (components) ->
    props = _.transform components, (p, cmp) =>
      p[cmp.region] = view: cmp.view, props: _.defaults(ref: cmp.region, cmp.props)
    , {}
    
    @_getView(props).then (siteViewInstance) -> _.pick(siteViewInstance.refs, _.pluck(components, 'region'))
