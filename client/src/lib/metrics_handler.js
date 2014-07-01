module.exports = {
  getComponentHierarchy: function(cmp) {
    var current = [];
    if (cmp) {
      if (this.getComponentType(cmp)) {
        current.push(cmp);
      }
      current = current.concat(this.getComponentHierarchy(cmp.clientMetricsParent));
    }
    return current;
  },

  getComponentType: function(cmp) {
    return (cmp.constructor && (cmp.constructor.displayName || cmp.constructor.name)) ||
           cmp.typePath ||
           (cmp.model && cmp.model.typePath) ||
           cmp.clientMetricsType;
  },

  getAppName: function(cmp) {
    return 'alm-mobile';
  }
};