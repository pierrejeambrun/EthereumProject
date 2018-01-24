<template>
  <div>
    <q-toolbar class="bg-tertiary">
      <q-toolbar-title  class="text-center" style="font-size: 1.5em">
        Node {{ node.ip }}
      </q-toolbar-title>
    </q-toolbar>
    <div class="fixed-center" style="width: 70%">
      <div v-if="blocks != null">
        <svg class="svgBC bg-primary" id="svgBC" height="600">
        </svg>
        <div class="row justify-between" style="max-width: 45%; margin-left: 25%">
          <q-btn v-if="delimiterBlocksId.tail != 0" color="primary" @click="previousButtonHandler()" big>
            <q-icon name="keyboard_arrow_left" />
            Previous Blocks
          </q-btn>
          <div v-else/>
          <q-btn v-if="delimiterBlocksId.head != latestBlock" color="primary" @click="nextButtonHandler()" big>
            Next Blocks
            <q-icon name="keyboard_arrow_right" />
          </q-btn>
        </div>
      </div>
      <div v-else class="fixed-center">
        <q-spinner-ios color="red" :size="100"> </q-spinner-ios>
      </div>
    </div>
    <q-modal ref="unreachableModal" v-model="nodeUnreachable" minimized>
      <q-toolbar>
        <q-btn flat @click="modalButtonClickedHandler()">
          <q-icon name="keyboard_arrow_left" />
        </q-btn>
        <div class="q-toolbar-title">
          Error :(
        </div>
      </q-toolbar>
      <div class="layout-padding">
        <p>The address {{ node.ip }} is unreachable, <br> verify that the node is up!</p>
        <q-btn color="red" @click="modalButtonClickedHandler()">Go Back</q-btn>
      </div>
    </q-modal>
    <q-modal ref="infoModal" minimized>
      <q-toolbar>
        <q-btn flat @click="$refs.infoModal.close()">
          <q-icon name="keyboard_arrow_left" />
        </q-btn>
        <div class="q-toolbar-title">
          Block Information
        </div>
      </q-toolbar>
      <div class="layout-padding" style="text-align: center; overflow: hidden">
        <p>{{ selectedBlock }}</p>
        <q-btn color="primary" @click="$refs.infoModal.close()">OK</q-btn>
      </div>
    </q-modal>
  </div>
</template>

<script type="text/javascript">
import * as d3 from "d3";
import httpService from "../../services/httpService";
import { QModal, QBtn, QToolbar, QIcon, QSpinnerIos, QToolbarTitle } from "quasar";

export default {
  name: "main-blockchain",
  components: {
    QModal,
    QBtn,
    QToolbar,
    QIcon,
    QSpinnerIos,
    QToolbarTitle
  },
  data: function() {
    return {
      blocks: null,
      node: this.$store.state.selectedNode,
      timer: null,
      latestBlock: null,
      nodeUnreachable: false,
      selectedBlock: null,
    }
  },
  computed: {
    delimiterBlocksId: function() {
      var currentHead = null;
      var currentTail = null;
      if (this.blocks == null) {
        return { tail: currentTail, head: currentHead };
      }
      for (let block of this.blocks) {
        let currentId = block.result.id;
        if (currentHead == null || currentId > currentHead) {
          currentHead = currentId;
        }
        if (currentTail == null || currentId < currentTail) {
          currentTail = currentId;
        }
      }
      return { tail: currentTail, head: currentHead };
    },
  },
  methods: {
    refreshData: function () {
      httpService.getBlockNumber(this.node.ip).then((response) => {
        let numberOfBlock = parseInt(response.data.result, 16);
        if (numberOfBlock != this.latestBlock && this.delimiterBlocksId.head == this.latestBlock) {
          // A new block came in, fetch it and update the visualization.
          this.getPreviousBlocks(numberOfBlock).then((responses) => {
            this.blocks = [];
            for (let response of responses) {
              response.body.result.id = parseInt(response.body.result.number, 16);
              this.blocks.push(response.body);
            }
            this.latestBlock = numberOfBlock;
            this.$nextTick(this.drawBlockchain);
          });
        }
        // No new block to fetch
      }, (error) => {
        this.nodeUnreachable = true;
      });
    },
    getPreviousBlocks: function (currentBlockId) {
      let numberOfBlockToRetrieve = 2; // Will retrieve numberOfBlockToRetrieve + 1 blocks
      let promises = [];
      for (let i = numberOfBlockToRetrieve; i >= 0; i--) {
        promises.push(httpService.getBlockByNumber(this.node.ip, currentBlockId - i));
      }
      return Promise.all(promises);
    },
    getNextBlocks: function (currentBlockId) {
      let numberOfBlockToRetrieve = 2; // Will retrieve numberOfBlockToRetrieve + 1 blocks
      let promises = [];
      for (let i = 0; i <= numberOfBlockToRetrieve; i++) {
        promises.push(httpService.getBlockByNumber(this.node.ip, currentBlockId + i));
      }
      return Promise.all(promises);
    },
    drawBlockchain: function() {
      var svg = d3.select("#svgBC");
      var width = parseInt(svg.style("width"));
      var height = parseInt(svg.style("height"));

      // Clear the svg for redraws
      svg.selectAll("*").remove();
      var blockWidth = width / 4.7;
      var blockHeight = height / 4;

      var group = svg.selectAll("g")
                  .data(this.blocks)
                .enter().append("g")
                .style("cursor", "pointer")
                .on("click", d => {
                  this.selectedBlock = d;
                  this.$refs.infoModal.open();
                });;

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
        .attr("width", blockWidth - paddingLeftRight)
        .attr("height", blockHeight - paddingLeftRight)
        .attr("group-anchor", "middle")
        .style("font-family", "Arial")
        .html(function(d) {return "<div style='overflow-y: hidden; height: " + (blockHeight - paddingTopBottom / 2) + "px' >" +
                                      "<div style='font-size: 20px;'>" +
                                        "Block id: " + d.result.id + "<br>" +
                                        "Nb Transac: " + d.result.transactions.length + "<br>" +
                                        "Difficulty: " + d.result.difficulty + "<br>" +
                                        "Gas used: "  + d.result.gasUsed + "<br>" +
                                        "Date: "+ new Date(parseInt(d.result.timestamp * 1000)) + "<br>" +
                                        "</div>" +
                                  "</div>";});

      group = group.data(this.blocks.filter((d) => {
        return parseInt(d.result.number, 16) != this.latestBlock;
      }));

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

      if (this.blocks[0].result.id != 0) {
        svg.append("line")
          .attr("x1", - paddingLeftRight / 2)
          .attr("y1", height / 2 - paddingTopBottom / 2)
          .attr("x2", blockWidth / 2 - paddingLeftRight / 2 - 5)
          .attr("y2", height / 2 - paddingTopBottom / 2)
          .attr("stroke-width", 1)
          .attr("stroke", "black")
          .attr("marker-end", "url(#triangle)");

        svg.append("svg:defs").append("svg:marker")
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
    modalButtonClickedHandler: function() {
      this.$router.push("/network");
    },
    nextButtonHandler: function () {
      this.getNextBlocks(Math.min(this.delimiterBlocksId.head + 1, this.latestBlock - 2)).then((responses) => {
        this.blocks = [];
        for (let response of responses) {
          response.body.result.id = parseInt(response.body.result.number, 16);
          this.blocks.push(response.body);
        }
        this.$nextTick(this.drawBlockchain);
      });
    },
    previousButtonHandler: function() {
      this.getPreviousBlocks(Math.max(this.delimiterBlocksId.tail - 1, 2)).then((responses) => {
        this.blocks = [];
        for (let response of responses) {
          response.body.result.id = parseInt(response.body.result.number, 16);
          this.blocks.push(response.body);
        }
        this.$nextTick(this.drawBlockchain);
      });
    }
  },
  mounted: function() {
    this.refreshData();
    if (this.timer == null) {
      this.timer = setInterval(() => this.refreshData(), 2000);
    }
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
    width: 100%
    border 1px solid black
    opacity 0.98
</style>