<template>
  <div>
    <q-modal ref="networkDetector" minimized @close="goBackButton">
      <q-toolbar>
        <q-btn flat @click="goBackButton()">
          <q-icon name="keyboard_arrow_left" />
        </q-btn>
        <div class="q-toolbar-title">
          Network Detector
        </div>
      </q-toolbar>
      <q-tabs>
        <!-- Tabs - notice slot="title" -->
        <q-tab default slot="title" name="tab-1" label="Static Discovery" />
        <q-tab slot="title" name="tab-2" label="Dynamic Discovery" />
        <!-- Targets -->

        <!-- Tab 1 -->
        <q-tab-pane name="tab-1">
          <div v-if="!scanningOver" class="layout-padding">
            <p>
              <b>Enter your Network Mask (/24)</b>
            </p>
            <p>
              <q-input v-model="mask" type="text" float-label="NetMask"/>
            </p>
            <div class="row justify-between">
              <q-btn color="red" @click="goBackButton()">Go Back</q-btn>
              <q-btn color="primary" @click="staticDetectNetworkButton()">Detect</q-btn>
            </div>
          </div>
          <div v-else class="layout-padding">
            <p v-html="postProcessResponse()"></p>
            <div class="text-center">
              <q-btn color="red" @click="okButton()">Ok</q-btn>
            </div>
          </div>
        </q-tab-pane>

        <!-- Tab 2 -->
        <q-tab-pane name="tab-2">
          <div v-if="!scanningOver" class="layout-padding">
            <p>
              <b>Enter the IP of one Node!</b>
            </p>
            <p>
              <q-input v-model="mask" type="text" float-label="NetMask"/>
            </p>
            <div class="row justify-between">
              <q-btn color="red" @click="goBackButton()">Go Back</q-btn>
              <q-btn color="primary" @click="dynamicDetectNetworkButton()">Detect</q-btn>
            </div>
          </div>
          <div v-else class="layout-padding">
            <p v-html="postProcessResponse()"></p>
            <div class="text-center">
              <q-btn color="red" @click="okButton()">Ok</q-btn>
            </div>
          </div>
        </q-tab-pane>
      </q-tabs>

      <q-progress :percentage="progress" color="primary" stripe animate style="height: 20px"/>
      </q-modal>
  </div>
</template>

<script type="text/javascript">
  import { QModal, QBtn, QToolbar, QIcon, QToolbarTitle, QInput, QProgress, QTabs, QTabPane, QTab } from 'quasar'
  import httpService from '../services/httpService';

  export default {
    name: 'presentation',
    components: {
      QBtn,
      QToolbar,
      QIcon,
      QToolbarTitle,
      QModal,
      QInput,
      QProgress,
      QTabs,
      QTabPane,
      QTab
    },
    data: function() {
      return {
        mask: null,
        nodes: [],
        progress: 0,
        processing: false,
        scanningOver: false
      }
    },
    mounted: function() {
      this.$refs.networkDetector.open();
    },
    methods: {
      goBackButton: function() {
        this.$router.push('/');
      },
      okButton: function() {
        this.$router.push('/network');
      },
      staticDetectNetworkButton: function() {
        if (this.processing) {
          return;
        }
        this.processing = true;
        var baseIp = this.mask.split(".").slice(0, -1).join(".");
        for (let i = 0; i <= 255; i++) {
          let currentIp = baseIp + "." + i;
            httpService.peers(currentIp).then((response) => {
              this.nodes.push(response.body.result);
              this.progress = this.progress + 1/256 * 100;
              if (this.progress == 100) {
                this.scanningOver = true;
                this.createNetwork();
              }
            }).catch((error)=> {
              this.progress = this.progress + 1/256 * 100;
              if (this.progress == 100) {
                this.scanningOver = true;
                this.createNetwork();
              }
            });
        }
      },
      dynamicDetectNetworkButton: function() {
        if (this.processing) {
          return;
        }
        console.log("Dynamic!");
        this.processing = true;
        this.scanningOver = true;
        this.createNetwork();

      },
      createNetwork: function() {
        let idMapping = {};
        let graph = {
          nodes: [],
          links: []
        };

        if (this.nodes.length == 0) {
          return;
        }

        // Create Id mapping
        for (let i = 0; i < this.nodes.length; i++) {
          let links = this.nodes[i];
          idMapping[links[0].network.localAddress.split(":")[0]] = i;
        }

        // Populate nodes and links
        for (let i  = 0; i < this.nodes.length; i++) {
          var links = this.nodes[i];
          var localAddress = links[0].network.localAddress.split(":")[0];
          graph.nodes.push({
            id: idMapping[localAddress],
            group: i,
            ip: localAddress
          });
          idMapping[links[0].network.localAddress.split(":")[0]] = i;
          for (let link of links) {
            graph.links.push({
              source: idMapping[link.network.localAddress.split(":")[0]],
              target: idMapping[link.network.remoteAddress.split(":")[0]]
            });
          }
        }

      // Filter double links
      let filteredGraph = {
        nodes: graph.nodes,
        links: []
      };

      for (let link of graph.links) {
        var known = false;
        for (let filteredLink of filteredGraph.links) {
          var ips = [idMapping[filteredLink.source], idMapping[filteredLink.target]];
          if (ips.includes(idMapping[link.source]) && ips.includes(idMapping[link.target])) {
            known = true;
            break;
          }
        }
        if (!known) {
          filteredGraph.links.push(link);
        }
      }
      this.processing = false;
      this.$store.commit("setGraph", filteredGraph);
      },
      postProcessResponse: function() {
        if (this.nodes.length > 0) {
          return "We successfully detected the network and found " + this.nodes.length + ` running nodes!  <br>
        The topology is saved.`
        } else {
          return `0 running nodes identified, verify the mask and that <br> your nodes are up!`
        }
      }
    }
  }

</script>

<style lang="stylus">
</style>