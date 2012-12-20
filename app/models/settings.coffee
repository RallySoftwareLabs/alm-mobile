BaseModel = require 'models/model'

module.exports = class SettingsModel extends BaseModel

  initialize: ->
    super
    # load/save settings from/to local storage
