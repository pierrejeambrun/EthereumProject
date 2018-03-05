<template>
  <div>
    <q-modal ref="networkDetector" minimized>
      <q-toolbar>
        <q-btn flat @click="goBackButton()">
          <q-icon name="keyboard_arrow_left" />
        </q-btn>
        <div class="q-toolbar-title">
          Network Detector
        </div>
      </q-toolbar>
      <div class="layout-padding">
        <p>helloBoloss</p>
        <div class="row justify-between"
        <q-btn color="red" @click="goBackButton()">Go Back</q-btn>
        <q-btn color="primary" @click="detectNetworkButton()">Detect</q-btn>
      </div>
    </q-modal>
  </div>
</template>

<script type="text/javascript">
  import { QModal, QBtn, QToolbar, QIcon, QToolbarTitle, } from 'quasar'

  export default {
    name: 'presentation',
    components: {
      QBtn,
      QToolbar,
      QIcon,
      QToolbarTitle,
      QModal
    },
    data: function() {
      return {
      }
    },
    mounted: function() {
      this.$refs.networkDetector.open();
    },
    methods: {
      goBackButton: function() {
        
      }
    }
  }

</script>

<style lang="stylus">
</style>