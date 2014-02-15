define ->
  return {
    getComponentHierarchy: (cmp) ->
      [cmp]

    getComponentType: (cmp) ->
      cmp.typePath || cmp.model?.typePath || cmp.constructor?.name

    getAppName: (cmp) ->
      'alm-mobile'

  }