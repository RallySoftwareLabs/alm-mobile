define [
  'hbsTemplate'
  'views/base/page_view'
], (hbs, PageView) ->

  class NavigationView extends PageView
    autoRender: true

    events:
      'click button[data-target]': 'doNavigate'

    template: hbs['navigation/templates/navigation']

    settings:
      workType: 'myWork'

    doNavigate: (e) ->
      @publishEvent '!router:route', e.currentTarget.getAttribute('data-target')

    afterRender: ->
      $('body').addClass('navigation')

    dispose: ->
      $('body').removeClass('navigation')
      super

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
