app = require('application')

$(->
  app.initialize()
  Backbone.history.start(
    pushState: true
  )
  $(document).on 'click', 'a:not([data-bypass])', (evt) ->

    href = $(this).attr('href')
    protocol = this.protocol + '//'

    if href.slice(protocol.length) isnt protocol
      evt.preventDefault()
      app.router.navigate(href, true)

  # Backbone.sync = (method, model, options) ->

)
