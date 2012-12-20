FieldDisplayView = require './field_display_view'

module.exports = FieldDisplayView.extend
	afterRender: ->
		FieldDisplayView.prototype.afterRender.call(this)
		@.$el.addClass('on') if @model.get(@options.field)
