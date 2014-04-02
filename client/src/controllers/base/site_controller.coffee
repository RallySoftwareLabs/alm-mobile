Controller = require 'controllers/base/controller'
SiteView = require 'views/site'

siteViewInstance = null

module.exports = class SiteController extends Controller

  _getView: (props, id) ->
    if siteViewInstance && siteViewInstance.isMounted()
      siteViewInstance.setProps props
    else
      siteViewInstance = null
      siteView = SiteView(props)

    if siteView
      siteViewInstance = React.renderComponent siteView, (if id then document.getElementById(id) else document.body)

    siteViewInstance.props.main

  renderReactComponent: (componentClass, props = {}, id) ->
    component = componentClass(_.omit(props, 'region'))

    props = {}
    props[name] = component
    @_getView props, id

  renderReactComponents: (components) ->
    props = _.reduce components, (p, cmp) =>
      component = cmp.componentClass(_.omit(cmp.props, 'region'))
      p[cmp.props.region] = component
      p
    , {}
    
    @_getView props
