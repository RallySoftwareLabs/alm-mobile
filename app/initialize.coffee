app = require 'application'
require 'backbone_mods'

$(->
  app.initialize()
  Backbone.history.start(
    # root: '/m'
    # pushState: true
  )
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
