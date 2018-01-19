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
  computed: {
    headBlock: function() {
      var currentHead = null;
      for (let block of this.blocks) {
        if (currentHead == null || block.id > currentHead) {
          currentHead = block;
        }
      }
      return currentHead;
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
      var paddingTopBottom = 20;

      group.append("rect")
        .attr("x", function(d, i) { return i * (blockWidth + blockWidth / 2) + blockWidth / 2 - paddingLeftRight / 2; })
        .attr("y", height / 2 - blockHeight / 2 - paddingTopBottom / 2)
        .attr("rx", 10)
        .attr("ry", 10)
        .attr("width", function(d) { return blockWidth; })
        .attr("height", function(d) { return blockHeight; })
        .attr("fill", "rgb(66, 165, 245")
        .style("stroke", "black")
        .style("stroke-width", 3);

      group.append("foreignObject")
        .attr("x", function(d, i) { return i * (blockWidth + blockWidth / 2) + blockWidth / 2; })
        .attr("y", height / 2 - blockHeight / 2)
        .attr("width", blockWidth)
        .attr("height", blockHeight - paddingLeftRight)
        .attr("group-anchor", "middle")
        .style("font-family", "Arial")
        .style("font-size", 20)
        .html(function(d) {return "<div>" +
                                      "Block id: " + d.id + "<br>" +
                                      "Nb Transac: " + d.result.transactions.length + "<br>" +
                                      "Difficulty: " + d.result.difficulty + "<br>" +
                                      "Gas used: "  + d.result.gasUsed + "<br>" +
                                      "Date: "+ new Date(parseInt(d.result.timestamp)) + "<br>" +
                                  "</div>";});

      group = group.data(this.blocks.filter((d) => d.id != this.headBlock.id));

      //Arrow
      group.append("line")
        .attr("x1", function(d, i) { return (i + 1) * (blockWidth + blockWidth / 2) - paddingLeftRight / 2; })
        .attr("y1", height / 2 - paddingTopBottom / 2)
        .attr("x2", function(d, i) { return (i + 1) * (blockWidth + blockWidth / 2) + blockWidth / 2 - paddingLeftRight / 2 - 5; })
        .attr("y2", height / 2 - paddingTopBottom / 2)
        .attr("stroke-width", 1)
        .attr("stroke", "black")
        .attr("marker-end", "url(#triangle)");

      group.append("svg:defs").append("svg:marker")
        .attr("id", "triangle")
        .attr("refX", 6)
        .attr("refY", 6)
        .attr("markerWidth", 30)
        .attr("markerHeight", 30)
        .attr("orient", "auto")
        .append("path")
        .attr("d", "M 0 0 12 6 0 12 3 6")
        .style("fill", "black");
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