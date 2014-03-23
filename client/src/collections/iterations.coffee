define ->
  moment = require 'moment'
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Iteration = require 'models/iteration'

  class Iterations extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/iteration'
    model: Iteration

    findClosestAsCurrent: ->
      now = moment()
      closestIteration = null
      closestDuration = null
      @each (iteration) ->
        startDate = new Date(iteration.get('StartDate'))
        thisDuration = Math.abs(now.diff(startDate))
        if startDate < now && new Date(iteration.get('EndDate')) > now
          closestIteration = iteration
          closestDuration = thisDuration
          return false

        if closestIteration
          if thisDuration < closestDuration
            closestIteration = iteration
            closestDuration = thisDuration
        else
          closestIteration = iteration
          closestDuration = thisDuration
      , null

      closestIteration
