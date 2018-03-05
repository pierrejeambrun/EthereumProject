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
      <div class="layout-padding">
        <p>
          Enter your network mask (/24)
        </p>
        <p>
          <q-input v-model="mask" type="text" float-label="NetMask"/>
        </p>
        <div class="row justify-between"
        <q-btn color="red" @click="goBackButton()">Go Back</q-btn>
        <q-btn color="primary" @click="detectNetworkButton()">Detect</q-btn>
      </div>
    </q-modal>
  </div>
</template>

<script type="text/javascript">
  import { QModal, QBtn, QToolbar, QIcon, QToolbarTitle, QInput } from 'quasar'

  export default {
    name: 'presentation',
    components: {
      QBtn,
      QToolbar,
      QIcon,
      QToolbarTitle,
      QModal,
      QInput
    },
    data: function() {
      return {
        mask: null
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

      }
    }
  }

</script>

<style lang="stylus">
</style>