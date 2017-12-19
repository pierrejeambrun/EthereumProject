<template>
  <div class="container row justify-center" @click="console.log('click')">
    <div class="message">Network Visualization Page</div>
    <svg width="50" height="50">
      <circle cx="25" cy="25" r="25" fill="purple" />
    </svg>
  </div>
</template>

<script type="text/javascript">
  var mockGraph = {};

  export default {
    name: 'network',
    data: function () {
      return {
        graphData: null
      }
    },
    mounted: function () {
      // Retrieve data for the graph,
      this.graphData = mockGraph;
      console.log("Data retrieved");
    },
    computed: {
      graph: function () {
        console.log("Graph computed!");
        return "toto";
      }
    } 
  }
</script>

<style lang="stylus">
.container
  width 100%
  height 100%

.message
  font-size 2em
</style>