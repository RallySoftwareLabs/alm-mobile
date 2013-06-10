define ->
	_ = require 'underscore'
	hbs = require 'hbsTemplate'
	View = require 'views/base/view'

	class ColumnView extends View
		template: hbs['board/templates/column']
		loadingIndicator: true

		initialize: (options = {}) ->
			super
			@model.synced => @render()
			@delegate 'click', => @trigger 'click', @model

		getTemplateData: ->
			storiesAndDefects = _.sortBy @model.artifacts().serialize(), 'Rank'
			header = @getColumnHeaderAbbreviation() + (if @model.isSynced() then " (#{storiesAndDefects.length})" else " ...")
			data = 
				header: header
				cards: storiesAndDefects

		getColumnHeaderAbbreviation: ->
			_.map(@model.get('value').replace(/-/g, ' ').split(' '), (word) -> word[0]).join ''
