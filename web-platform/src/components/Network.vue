<template>
  <div class="container row justify-center">
    <div class="message">Network Visualization Page</div>
    <div style="width: 100%"/>
    <svg class="svg" id="svg1" width="100%" height="500">
    </svg>
  </div>
</template>

<script type="text/javascript">
  import * as d3 from "d3";
  import { Node } from "structures/Nodes"
  import graph from "../assets/data/mock/mockGraph.json"

  var mockGraph = require("../assets/data/mock/mockGraph.json");

  export default {
    name: "network",
    data: function() {
      return {
        graphData: null,
        simulatoin: null        
      }
    },
    mounted: function() {
      // Retrieve data for the graph,
      this.graphData = mockGraph;
      console.log("Data retrieved");
      var svg = d3.select("#svg1");
      var width = parseInt(svg.style("width"));
      var height = parseInt(svg.style("height"));

      var color = d3.scaleOrdinal(d3.schemeCategory20);
      var simulation = d3.forceSimulation()
        .force("link", d3.forceLink().id(function(d) { return d.id; }))
        .force("charge", d3.forceManyBody())
        .force("center", d3.forceCenter(width/2, height/2));

      this.simulation = simulation;

      var link = svg.append("g")
        .attr("class", "links")
        .selectAll(".links")
        .data(mockGraph.links)
        .enter().append("line")
        .attr("stroke-width", function(d) { return Math.sqrt(d.value); });

      var node = svg.append("g")
        .attr("class", "nodes")
        .selectAll(".node")
        .data(mockGraph.nodes)
        .enter().append("circle")
          .attr("r", 5)
          .attr("fill", function(d) { return color(d.group); })
        .call(d3.drag()
        .on("start", dragstarted)
        .on("drag", dragged)
        .on("end", dragended))
        .on("click", function() { console.log("Node clicked"); });
      
      var label = svg.selectAll(".myText")
        .data(mockGraph.nodes)
        .enter()
        .append("text")
        .text(function(d) { return d.group ;})
        .style("text-anchor", "middle")
        .style("fill", "#555")
        .style("font-family", "Arial")
        .style("font-size", 12);

      simulation
        .nodes(mockGraph.nodes)
        .on("tick", ticked);

      simulation.force("link")
        .links(mockGraph.links);

      function ticked() {
        link
            .attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });

        node
            .attr("cx", function(d) { return d.x; })
            .attr("cy", function(d) { return d.y; });

        label
            .attr("x", function(d){ return d.x; })
            .attr("y", function (d) {return d.y - 10; });
      }

      function dragstarted(d) {
      if (!d3.event.active) simulation.alphaTarget(0.3).restart();
        d.fx = d.x;
        d.fy = d.y;
      }

      function dragged(d) {
        d.fx = d3.event.x;
        d.fy = d3.event.y;
      }

      function dragended(d) {
        if (!d3.event.active) simulation.alphaTarget(0);
        d.fx = null;
        d.fy = null;
      }
      window.addEventListener('resize', this.handleResize);
    },
    delete: function() {
      window.removeEventListener('resize', this.handleResize);
    },
    computed: {
    },
    methods: {
      handleResize: function(event) {
        var svg = d3.select("#svg1");
        var width = parseInt(svg.style("width"));
        var height = parseInt(svg.style("height"));
        if (this.simulation) {
          this.simulation.force("center", d3.forceCenter(width/2, height/2));
        }
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

.svg
  width 90%
  border 1px solid lightgrey

.links line
  stroke: #999;
  stroke-opacity: 0.6;

.nodes circle
  stroke: #fff;
  stroke-width: 1.5px;

.node text
  pointer-events none
  font: 10px sans-serif
</style>