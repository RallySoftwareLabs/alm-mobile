View = require('./view')
template = require('./templates/login')

module.exports = View.extend
  id: 'login-view'
  template: template
  events:
    'click .sign-in': 'signIn'

  signIn: ->
    
