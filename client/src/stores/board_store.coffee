_ = require 'underscore'
app = require 'application'
utils = require 'lib/utils'
Artifacts = require 'collections/artifacts'
Column = require 'models/column'
UserStory = require 'models/user_story'
BaseStore = require 'stores/base_store'

module.exports = class BoardStore extends BaseStore
  constructor: ({@boardField, @boardColumns, @project, @iteration, @iterations, @user, @visibleColumn}) ->
    @columns = @_getColumnModels()

  load: ->
    @artifacts = new Artifacts()
    @artifacts.clientMetricsParent = this

    @_fetchCards().then =>
      app.aggregator.recordComponentReady component: this

  getColumns: -> @columns

  getVisibleColumns: ->
    if @visibleColumn
      _.filter @columns, _.isAttributeEqual('value', @visibleColumn)
    else
      @columns

  showOnlyColumn: (@visibleColumn) ->
    @trigger 'change'

  isZoomedIn: -> !!@visibleColumn

  getIteration: -> @iteration

  getIterations: -> @iterations

  setIteration: (@iteration) ->
    @artifacts.reset()
    _.each @columns, (col) -> col.artifacts.reset()
    @trigger 'change'
    @_fetchCards()

  _getColumnModels: ->
    _.map @boardColumns, (value) =>
        col = new Column({@boardField, value})
        col.clientMetricsParent = this
        col

  _fetchCards: ->
    @artifacts.fetch(@_getFetchData(@boardColumns)).then =>
      @artifacts.each (artifact) =>
        column = _.find @columns, _.isAttributeEqual('value', artifact.get(@boardField))
        column.artifacts.add artifact
        
      _.invoke(@columns, 'trigger', 'sync')
      @trigger 'change'

  _getFetchData: (values) ->
    colQuery = utils.createQueryFromCollection(values, @boardField, 'OR', (value) ->
      "\"#{value}\""
    )
    data =
      fetch: "#{@boardField},FormattedID,DisplayColor,Blocked,Ready,Name,Owner,PlanEstimate,Tasks:summary[State;Estimate;ToDo;Owner;Blocked],TaskStatus,Defects:summary[State;Owner],DefectStatus,Discussion:summary"
      query: "(#{colQuery} AND ((Requirement = null) OR (DirectChildrenCount = 0)))"
      types: 'hierarchicalrequirement,defect'
      order: "Rank ASC"
      pagesize: 100
      project: @project.get('_ref')
      projectScopeUp: false
      projectScopeDown: true

    if @user
      data.query = "(#{data.query} AND (Owner = \"#{@user.get('_ref')}\"))"

    iterationRef = @iteration?.get('_ref')
    if iterationRef
      data.query = "(#{data.query} AND (Iteration = \"#{iterationRef}\"))"

    data: data
