define ->
  _ = require 'underscore'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  WallView = require 'views/wall/wall'

  class WallController extends SiteController
    index: (params) ->
      @whenLoggedIn =>
        flipcharts = @getFlipcharts "Initiative"
        @view = @renderReactComponent WallView, flipcharts: flipcharts, region: 'main'
        
    getFlipcharts: (type) ->
        return [
          {formattedID: "I2921", name: "Spike and define path towards ...", owner: "Method Marc	XL"},
          {formattedID: "I2912", name: "Improve via a ....... - OPEN PREVIEW", owner: "Steve Stolt"},	
          {formattedID: "I2968", name: "GTM and start of execution - Announce by end of 2014-Q1", owner: "Mark Smith"},
          {formattedID: "I2962", name: "Project-Level Administration (committed to XX and XX)", owner: "Steph"},	
          {formattedID: "I2960", name: "Standard OAuth Authentication for Internal and External", owner: "Eric The PO"},
          {formattedID: "I2981", name: "Be on glide path to deliver the ... at RallyOn", owner: "Brent Barton"},	
          {formattedID: "I2937", name: "Some Features for Aligned Organizations", owner: "Susan	S"},
          {formattedID: "I2849", name: "T... in Team Inbox", owner: "Mikael"},	
          {formattedID: "I2850", name: "ALM-... integration", owner: "Mikael"}
        ]