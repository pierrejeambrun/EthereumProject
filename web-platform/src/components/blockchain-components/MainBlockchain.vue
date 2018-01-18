<template>
  <div class="container row justify-center">
    <div class="message text-primary">Node {{ currentNode ? currentNode.ip : ""}} </div>
    <svg class="svgBC bg-primary fixed-center" id="svgBC" height="600">
    </svg>
  </div>
</template>

<script type="text/javascript">
import * as d3 from "d3";

export default {
  name: "main-blockchain",
  data: function() {
    return {
      blocks: require("../../assets/data/mock/mockBlockChain.json"),
      currentNode: this.$store.state.selectedNode,
      timer: null
    }
  },
  methods: {
    refreshData: function () {
      this.$http.get('https://httpbin.org/get').then(response =>
      {
        console.log("Refreshed! ");
        console.log(response.data);
      });
    },
    drawBlockchain: function() {
      var svg = d3.select("#svgBC");
      var width = parseInt(svg.style("width"));
      var height = parseInt(svg.style("height"));

      var blockWidth = width / 5;
      var blockHeight = height / 4;

      var group = svg.selectAll("g")
                  .data(this.blocks)
                .enter().append("g");

      var paddingLeftRight = 18;
      var paddingTopBottom = 50;

      group.append("rect")
        .attr("x", function(d, i) { return i * (blockWidth + blockWidth / 2) + blockWidth / 2 - paddingLeftRight/2; })
        .attr("y", function(d) { return height / 2 - blockHeight / 2 - paddingTopBottom/2; })
        .attr("width", function(d) { return blockWidth; })
        .attr("height", function(d) { return blockHeight; })
        .attr("fill", "#555");

      group.append("text")
        .attr("x", function(d, i) { return i * (blockWidth + blockWidth / 2) + blockWidth / 2; })
        .attr("y", function(d) { return height / 2 - blockHeight / 2; })
        .attr("fill", "#FFF")
        .attr("group-anchor", "middle")
        .style("font-family", "Arial")
        .text(function(d) { return d.id + "\n" + "Second line"; });
    }
  },
  mounted: function() {
    this.refreshData();
    if (this.timer == null) {
      this.timer = setInterval(() => this.refreshData(), 2000);
    }
    this.drawBlockchain();
  },
  beforeDestroy: function () {
    clearInterval(this.timer);
  }
} 
</script>

<style lang="stylus">
  .message
    font-size 2.5em

  .svgBC
    width: 70%
    border 1px solid black
    opacity 0.98
</style>