module.exports = {
    planStatus: (userStory) ->
      return this.props.planStatus if this.props.planStatus
      if userStory?
        return 'completed' if @isCompleted(userStory) 
        return 'scheduled' if @isScheduled(userStory)  
        return 'unscheduled'
    
    isCompleted: (userStory) ->
      userStory.get('ScheduleState') is 'Accepted' or userStory.get('ScheduleState') is 'Released' 
      
    isScheduled: (userStory) ->
      userStory.get('Release') or userStory.get('Iteration')

    collectionPlanStatus: (collection) ->
      return 'unscheduled' if !collection?
      return 'unscheduled' if collection.isEmpty()
      return 'scheduled' if collection.every (userStory) =>
        @isScheduled(userStory)

    iterationPlanStatus: (iteration) ->
      return 'overloaded' if @loadFactor(iteration) > .1
      return 'sketchy' if !iteration.get('plannedVelocity')
      return 'sketchy' if !iteration.get()

    loadPercentage: (iteration) ->
      if iteration.get('PlannedVelocity')?
        loadFactor = @planEstimateTotal(iteration)/iteration.get('PlannedVelocity')
        Math.round(loadFactor * 100)
        
    planEstimateTotal: (iteration) ->
      planEstimates = []
      if iteration.artifacts?
        iteration.artifacts.reduce (total, artifact) ->
          total + artifact.get('PlanEstimate')
        , 0
      else 0

    loadStatus: (iteration) ->
      percentage = @loadPercentage(iteration)
      return 'overloaded' if percentage > 100
      return 'high' if percentage > 70
      return 'responsive' if percentage > 40
      return 'unknown'
  }