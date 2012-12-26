BaseView = require 'views/view'
template = require './templates/navigation'

module.exports = class NavigationView extends BaseView

  initialize: (options) ->
    @router = options.router

  events:
    'click button[data-target]': 'doNavigate'

  template: template

  settings:
    workType: 'myWork'

  doNavigate: (e) ->
    @router.navigate e.currentTarget.getAttribute('data-target'), trigger: true

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
        viewHash: 'home'
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
