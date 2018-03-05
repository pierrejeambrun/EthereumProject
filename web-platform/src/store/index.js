import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

var mockGraph = require("../assets/data/blockChainNodes.json");

const store = new Vuex.Store({
  state: {
    graphData: mockGraph,
    selectedNode: mockGraph.nodes[0]
  },
  actions: {

  },
  mutations: {
    setGraph: function(state, newGraph) {
        state.graphData = newGraph;
    },
    setSelectedNode: function(state, node) {
      state.selectedNode = node;
    }
  },
  getters: {
  }
})
export default store