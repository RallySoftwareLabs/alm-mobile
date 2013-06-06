define [
  'models/base/model'
], (Model) ->

  class Settings extends Model

    initialize: ->
      super
      # load/save settings from/to local storage
