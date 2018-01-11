import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

var mockGraph = require("../assets/data/mock/mockBlockChainNodes.json");

const store = new Vuex.Store({
  state: {
    graphData: mockGraph,
    selectedNodeId: null
  },
  actions: {

  },
  mutations: {
    setGraph: function(state, newGraph) {
        state.graphData = newGraph;
    },
    setSelectedNodeId: function(state, Id) {
      state.selectedNodeId = Id;
    }
  },
  getters: {
  }
})
export default store