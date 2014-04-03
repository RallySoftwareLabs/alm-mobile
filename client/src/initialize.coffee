require 'jquery'
require 'backbone'
app = require 'application'
require 'backbone_mods'

if window.initializeApp
  $(document).ready ->
    app.initialize()
