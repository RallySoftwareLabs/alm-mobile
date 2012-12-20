template  = require './templates/navigation'

module.exports = Backbone.View.extend

  initialize: (options) ->
    @router = options.router
    @render()

  el: '#content'

  events:
    'click button[data-target]': 'clickedButton'

  template: template

  settings:
    workType: 'myWork'

  clickedButton: (e) ->
    console.log 'nav to', e.currentTarget.getAttribute 'data-target'
    @router.navigate e.currentTarget.getAttribute('data-target'), trigger: true

  getSetting: (setting) -> @settings[setting]

  getRenderData: ->
    timeRemaining: 4
    timeRemainingUnits: 'days'
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
  render: ->
    @$el.html @template @getRenderData()
    @
