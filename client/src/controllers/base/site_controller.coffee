Controller = require 'controllers/base/controller'
SiteView = require 'views/site'

siteView = null

module.exports = class SiteController extends Controller

  _getView: (props) ->
    if siteView && siteView.isMounted()
      siteView.setProps props
    else
      siteView = SiteView(props)

    siteView

  _setSubView: (name, view) ->
    props ={}
    props[name] = view
    @_getView(props)

  renderReactComponent: (componentClass, props = {}, id) ->
    component = componentClass(_.omit(props, 'region'))

    siteView = @_setSubView props.region, component

    unless siteView.isMounted()
      siteView.renderForBackbone id

    component