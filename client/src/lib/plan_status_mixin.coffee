define ->
  return {
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


  }