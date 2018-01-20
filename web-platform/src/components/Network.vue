<template>
  <div class="container row justify-center">
    <div class="message text-primary">Network Visualization Page</div>
    <svg class="svg bg-primary fixed-center" id="svg1" height="600">
    </svg>
    <q-modal ref="layoutModal" v-model="open"  @open="fixeWitdh" minimized>
      <q-toolbar>
        <q-btn flat @click="open = false ;$refs.layoutModal.close()">
          <q-icon name="keyboard_arrow_left" />
        </q-btn>
        <div class="q-toolbar-title">
          Information on Node {{ selectedNode ? selectedNode.id : ""}}
        </div>
      </q-toolbar>
      <div class="layout-padding">
        <h3>Information</h3>
        <q-list separator>
          <q-collapsible icon="home" label="Ip Address" :sublabel="selectedNode ? selectedNode.ip : 'x.x.x.x'">
            <div>
              PeerCount: 0x0
            </div>
          </q-collapsible>
          <q-collapsible icon="perm_identity" label="Node State">
            <div>
              Is Mining: True
            </div>
          </q-collapsible>
          <q-collapsible icon="shopping_cart" label="Eth Accounts" id="element">
            <div style="word-break: break-all">
              0xd19167868388e320f09d5de3f8d5927f78bc6ce4
            </div>
          </q-collapsible>
        </q-list>
        <br>
        <div class="row justify-between">
          <q-btn color="primary" @click="goToBlockChain(selectedNode)">Blochain</q-btn>
          <q-btn color="primary" @click="$refs.layoutModal.close()">Close</q-btn>
        </div>
      </div>
    </q-modal>
  </div>
</template>

<script type="text/javascript">
  import * as d3 from "d3"
  import { Node } from "structures/Nodes"
  import { QModal, QBtn, QToolbar, QIcon, QToolbarTitle, QList, QCollapsible } from "quasar"

  var mockGraph = require("../assets/data/mock/mockBlockChainNodes.json");

  export default {
    name: "network",
    components: {
      QModal,
      QBtn,
      QToolbar,
      QIcon,
      QToolbarTitle,
      QList,
      QCollapsible
    },
    data: function() {
      return {
        simulation: null,
        open: false,
        selectedNode: null
      }
    },
    mounted: function() {
      this.drawGraph();
    },
    computed: {
      graphData: {
        get: function() {
          return this.$store.state.graphData;
        },
        set: function(newGraph) {
          this.$store.commit("setGraph", newGraph);
        }
      }
    },
    methods: {
      drawGraph: function() {
        // Retrieve data for the graph,
        this.graphData = mockGraph;
        var svg = d3.select("#svg1");
        var width = parseInt(svg.style("width"));
        var height = parseInt(svg.style("height"));

        var color = d3.scaleOrdinal(d3.schemeCategory20);
        var simulation = d3.forceSimulation()
          .force("link", d3.forceLink().id(function(d) { return d.id; }))
          .force("link", d3.forceLink().distance(function(d) { return height/2;}).strength(1))
          .force("charge", d3.forceManyBody().strength(-2500))
          .force("center", d3.forceCenter(width/2, height/2));

        this.simulation = simulation;

        var link = svg.append("g")
          .attr("class", "links")
          .selectAll(".links")
          .data(this.graphData.links)
          .enter().append("line")
          // .attr("stroke-width", function(d) { return Math.sqrt(d.value); });
          .attr("stroke-width", 2);

        var node = svg.append("g")
          .style("cursor", "pointer")
          .attr("class", "nodes")
          .selectAll(".node")
          .data(this.graphData.nodes)
          .enter().append("circle")
            .attr("r", 12)
            .attr("fill", function(d) { return color(d.group); })
          .call(d3.drag()
          .on("start", dragstarted)
          .on("drag", dragged)
          .on("end", dragended))
          .on("click", d => {
            this.selectedNode = this.graphData.nodes[d.index];
            this.$refs.layoutModal.open();
          });

        var label = svg.selectAll(".myText")
          .data(this.graphData.nodes)
          .enter()
          .append("text")
          .text(function(d) { return d.ip ;})
          .style("text-anchor", "middle")
          .style("fill", "#000000")
          .style("font-family", "Arial")
          .style("font-size", 13);

        simulation
          .nodes(this.graphData.nodes)
          .on("tick", ticked);

        simulation.force("link")
          .links(this.graphData.links);

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
              .attr("x", function(d) { return d.x; })
              .attr("y", function (d) { return d.y - 10; });
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
      handleResize: function(event) {
        var svg = d3.select("#svg1");
        var width = parseInt(svg.style("width"));
        var height = parseInt(svg.style("height"));
        if (this.simulation) {
          this.simulation.force("center", d3.forceCenter(width/2, height/2));
        }
      },
      goToBlockChain: function(node) {
        this.$store.commit("setSelectedNode", node);
        this.$router.push({ path: "/blockchain"});
      },
      fixeWitdh: function() {
        $("#element").css("max-width", $("#element").width());
      }
    },
    destroyed: function() {
        window.removeEventListener('resize', this.handleResize);
    }
  }
</script>

<style lang="stylus">
.message
  font-size 2.5em

.svg
  width 70%
  border 1px solid black
  opacity 0.98

.links line
  stroke: #999;
  stroke-opacity: 1;

.nodes circle
  stroke: #fff;
  stroke-width: 0.5px;
  opacity: 1;
</style>