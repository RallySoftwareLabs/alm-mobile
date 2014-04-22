$ = require 'jquery'
Controller = require 'controllers/base/controller'
SiteView = require 'views/site'

siteViewInstance = null

module.exports = class SiteController extends Controller

  _getView: (props, id) ->
    deferred = $.Deferred()
    if siteViewInstance && siteViewInstance.isMounted()
      siteViewInstance.setProps props, ->
        deferred.resolve(siteViewInstance.refs.main)
    else
      siteViewInstance = null
      siteView = SiteView(props)

    if siteView
      siteViewInstance = React.renderComponent siteView, (if id then document.getElementById(id) else document.body)
      deferred.resolve(siteViewInstance.refs.main)

    deferred.promise()

  renderReactComponent: (componentClass, props = {}, id) ->
    viewProps = {}
    viewProps[props.region] = cmp: componentClass, props: _.defaults(ref: props.region, _.omit(props, 'region'))
    @_getView viewProps, id

  renderReactComponents: (components) ->
    props = _.reduce components, (p, cmp) =>
      p[cmp.props.region] = cmp: cmp.componentClass, props: _.defaults(ref: props.region, _.omit(props, 'region'))
      p
    , {}
    
    @_getView props
