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
      <div v-if="!scanningOver" class="layout-padding">
        <p>
          Enter your network mask (/24)
        </p>
        <p>
          <q-input v-model="mask" type="text" float-label="NetMask"/>
        </p>
        <div class="row justify-between">
          <q-btn color="red" @click="goBackButton()">Go Back</q-btn>
          <q-btn color="primary" @click="detectNetworkButton()">Detect</q-btn>
        </div>
      </div>
      <div v-else class="layout-padding">
        <p v-html="postProcessResponse()"></p>
        <div class="text-center">
          <q-btn color="red" @click="goBackButton()">Ok</q-btn>
        </div>
      </div>
      <q-progress :percentage="progress" color="primary" stripe animate style="height: 20px"/>
    </q-modal>
  </div>
</template>

<script type="text/javascript">
  import { QModal, QBtn, QToolbar, QIcon, QToolbarTitle, QInput, QProgress } from 'quasar'
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
      QProgress
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
      detectNetworkButton: function() {
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
      createNetwork: function() {
        let graph = {
          nodes: [],
          links: []
        };
        for (let i  = 0; i < this.nodes.length; i++) {
          var links = this.nodes[i];
          graph.nodes.push({
            id: i,
            group: i,
            ip: links[0].network.localAddress.split(":")[0]
          });
          for (let link of links) {
            graph.links.push({
              source: link.network.localAddress.split(":")[0],
              target: link.network.remoteAddress.split(":")[0]
            });
          }
        }
      let filteredGraph = {
        nodes: graph.nodes,
        links: []
      };

      for (let link of graph.links) {
        var known = false;
        for (let filteredLink of filteredGraph.links) {
          var ips = [filteredLink.source, filteredLink.target]
          if (ips.includes(link.source) && ips.includes(link.target)) {
            known = true;
            break;
          }
        }
        if (!known) {
          filteredGraph.links.push(link);
        }
      }
      this.processing = false;
      // Write the graph in the file.
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