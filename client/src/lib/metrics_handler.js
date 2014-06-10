module.exports = {
  getComponentHierarchy: function(cmp) {
    var current = [];
    if (cmp) {
      if (this.getComponentType(cmp)) {
        current.push(cmp);
      }
      current.concat(this.getComponentHierarchy(cmp.clientMetricsParent));
    }
  },

  getComponentType: function(cmp) {
    return cmp.typePath ||
      (cmp.model && cmp.model.typePath) ||
      cmp.clientMetricsType ||
      (cmp.constructor && cmp.constructor.name);
  },

  getAppName: function(cmp) {
    return 'alm-mobile';
  }
};