FieldDisplayView = require './field_display_view'

module.exports = class FieldDisplayToggleView extends FieldDisplayView
	initialize: (config) ->
		config.viewType = 'string'
		super config
		
	afterRender: ->
		FieldDisplayView.prototype.afterRender.call(this)
		@.$el.addClass('on') if @model.get(@options.field)
