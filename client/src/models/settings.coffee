define ['models/model'], (Model) ->

  class SettingsModel extends Model

    initialize: ->
      super
      # load/save settings from/to local storage
