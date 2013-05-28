# Require.js Configurations
# -------------------------
require.config({

  # Sets the js folder as the base directory for all future relative paths
  baseUrl: "../"

  paths:
    spin: '../../vendor/scripts/spin-1.2.7.js'

  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:

      # Backbone
      "backbone":

        # Depends on underscore/lodash and jQuery
        "deps": ["underscore", "jquery"]

        # Exports the global window.Backbone object
        "exports": "Backbone"

})