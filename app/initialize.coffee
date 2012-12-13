application = require('application')

$(->
  application.initialize()
  Backbone.history.start(
    pushState: true
  )
)
