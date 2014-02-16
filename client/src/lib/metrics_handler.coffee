define ->
  return {
    getComponentHierarchy: (cmp) ->
      if cmp
        [cmp].concat @getComponentHierarchy(cmp.clientMetricsParent)
      else
        []

    getComponentType: (cmp) ->
      cmp.typePath || cmp.model?.typePath || cmp.clientMetricsType || cmp.constructor?.name

    getAppName: (cmp) ->
      'alm-mobile'

  }