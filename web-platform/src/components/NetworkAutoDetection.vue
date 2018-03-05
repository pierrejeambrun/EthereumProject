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
      <div v-if="!detectionOver" class="layout-padding">
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
        We successfully detected the network and <br> found {{ nodes.length }} running nodes!
        The network topology is saved.
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
        detectionOver: false
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
        var baseIp = this.mask.split(".").slice(0, -1).join(".");
        for (let i = 0; i <= 255; i++) {
          let currentIp = baseIp + "." + i;
            httpService.peers(currentIp).then((response) => {
              this.nodes.push(response);
              this.progress = this.progress + 1/256 * 100;
              if (this.progress == 100) {
                this.detectionOver = true;
                this.createNetwork();
              }
            }).catch((error)=> {
              this.progress = this.progress + 1/256 * 100;
              if (this.progress == 100) {
                this.detectionOver = true;
                this.createNetwork();
              }
            });
        }
      },
      createNetwork: function() {
        console.log(this.nodes);
      }
    }
  }

</script>

<style lang="stylus">
</style>