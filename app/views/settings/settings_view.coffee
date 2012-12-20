BaseView = require '../view'
template  = require './templates/settings'

module.exports = class SettingsView extends BaseView

  el: '#content'

  template: template

  getRenderData: ->
    projects: [
      { name: 'Project 1' }
      { name: 'Project 2' }
      { name: 'Project 3' }
    ]
