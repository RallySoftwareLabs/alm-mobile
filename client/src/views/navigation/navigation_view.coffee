define [
  'views/view'
], (View) ->

  class NavigationView extends View

    initialize: (options) ->
      @router = options.router

    events:
      'click button[data-target]': 'doNavigate'

    template: JST['navigation/templates/navigation']

    settings:
      workType: 'myWork'

    doNavigate: (e) ->
      @router.navigate e.currentTarget.getAttribute('data-target'), trigger: true

    afterRender: ->
      $('body').addClass('navigation')

    remove: ->
      $('body').removeClass('navigation')

    getSetting: (setting) -> @settings[setting]

    getRenderData: ->
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
