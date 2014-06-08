var actions = {
  setMode: function(mode) {
    this.dispatch('setMode', mode);
  },

  setBoardField: function(boardField) {
    this.dispatch('setBoardField', boardField);
  },

  setProject: function(project) {
    this.dispatch('setProject', project);
  },

  setIteration: function(iteration) {
    this.dispatch('setIteration', iteration);
  },

  toggleBoardColumn: function(column) {
    this.dispatch('toggleBoardColumn', column);
  }

};

module.exports = actions;