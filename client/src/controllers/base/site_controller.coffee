$ = require 'jquery'
RegionController = require 'controllers/base/region_controller'
SiteView = require 'views/site'

siteViewInstance = null

module.exports = class SiteController extends RegionController
  view: SiteView
