<template>
  <div class="container row justify-center">
    <div class="message">Network Visualization Page</div>
    <div style="width: 100%"/>
    <svg id="svg1" width="100%" height="500">
    </svg>
  </div>
</template>

<script type="text/javascript">
  import * as d3 from "d3";

  var mockGraph = {};

  export default {
    name: "network",
    data: function() {
      return {
        graphData: null
      }
    },
    mounted: function() {
      // Retrieve data for the graph,
      this.graphData = mockGraph;
      console.log("Data retrieved");
      var svd = d3.select("#svg1")
      svd.on("click", function () {
        var coords = d3.mouse(this);
        console.log(coords);
        console.log("Drawing a cercle at " + coords[0] + " " + coords[1]);
        svd.append("circle").attr("cx", coords[0]).attr("cy", coords[1]).attr("r", 25).attr("fill", "blue");
      });
    },
    computed: {
      graph: function() {
        console.log("Graph computed!");
        return "toto";
      }
    },
    methods: {
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