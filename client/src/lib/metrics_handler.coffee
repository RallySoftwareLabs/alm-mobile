define ->
  return {
    getComponentHierarchy: (cmp) ->
      if cmp
        current = if @getComponentType(cmp)
          [cmp]
        else
          []
        current.concat @getComponentHierarchy(cmp.clientMetricsParent)
      else
        []

    getComponentType: (cmp) ->
      cmp.typePath || cmp.model?.typePath || cmp.clientMetricsType || cmp.constructor?.name

    getAppName: (cmp) ->
      'alm-mobile'

  }