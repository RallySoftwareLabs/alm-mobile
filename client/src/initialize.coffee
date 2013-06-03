require [
  'jquery'
  'backbone'
  'bootstrap'
  'application'
  'backbone_mods'
  'lib/router'
  'models/user'
  'models/authentication'
], ($, Backbone, Bootstrap, app, backboneMods, Router, User, Session) ->

  $(->
    app.initialize(Router, User, Session)
    $(document).on 'click', 'a:not([data-bypass])', (evt) ->

      href = $(this).attr('href')
      protocol = this.protocol + '//'

      if href.slice(protocol.length) isnt protocol
        evt.preventDefault()
        if href is '#back'
          window.history.back()
        else
          app.router.navigate(href, trigger: true)
  )
