import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

var mockGraph = require("../assets/data/mock/mockBlockChainNodes.json");

const store = new Vuex.Store({
  state: {
    graphData: mockGraph
  },
  actions: {

  },
  mutations: {
    setGraph: function(state, newGraph) {
        state.graphData = newGraph;
    }
  },
  getters: {
  }
})
export default store