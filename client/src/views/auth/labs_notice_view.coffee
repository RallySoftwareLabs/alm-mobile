define [
  'hbsTemplate'
  'application'
  'views/base/view'
  'collections/users'
], (hbs, app, View, Users) ->

  class LabsNoticeView extends View
    autoRender: true
    container: 'body'
    id: 'labs-notice'
    className: 'container'
    template: hbs['auth/templates/labs_notice']
    events:
      'click .accept': 'accept'
      'touchstart .accept': 'accept'
      'click .reject': 'reject'
      'touchstart .reject': 'reject'

    accept: (event) ->
      @trigger 'accept'
      event.preventDefault()

    reject: (event) ->
      @trigger 'reject'
      event.preventDefault()
