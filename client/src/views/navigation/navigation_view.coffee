define [
  'hbsTemplate'
  'views/base/view'
], (hbs, View) ->

  class NavigationView extends View
    autoRender: true
    region: 'navigation'

    events:
      'click button[data-target]': 'doNavigate'

    template: hbs['navigation/templates/navigation']

    settings:
      workType: 'myWork'

    initialize: ->
      super
      @subscribeEvent 'navigation:show', @onNavigationShow

    doNavigate: (e) ->
      @$el.parent().attr('class', @$el.parent().attr('class').replace(/center/, 'left'))
      $('#page-container').attr('class', $('#page-container').attr('class').replace(/right/, 'center'))

      currentRoute = window.location.pathname
      newRoute = e.currentTarget.getAttribute('data-target')

      @publishEvent 'navigation:hide'
      unless newRoute == currentRoute || (newRoute == '' && _.contains(['/userstories', '/tasks', '/defects'], currentRoute))
        @publishEvent '!router:route', newRoute

    onNavigationShow: ->
      $('#page-container').attr('class', $('#page-container').attr('class').replace(/(\spage\stransition\scenter)?$/, ' page transition right'))
      @$el.parent().attr('class', @$el.parent().attr('class').replace(/(transition\s)?left/, 'transition center'))

    getSetting: (setting) -> @settings[setting]

    getTemplateData: ->
      timeRemaining: 4
      timeRemainingUnits: 'Days'
      percentAccepted: 50
      pointsAccepted: 6
      totalPoints: 12
      activeDefects: 3
      buttons: [
        {
          displayName: if @getSetting('workType') is 'myWork' then 'My Work' else 'My Team'
          viewHash: ''
        }
        {
          displayName: 'Tracking Board'
          viewHash: 'board'
        }
        {
          displayName: 'Burndown Chart'
          viewHash: 'burndown'
        }
        {
          displayName: 'Recent Activity'
          viewHash: 'recentActivity'
        }
      ]
