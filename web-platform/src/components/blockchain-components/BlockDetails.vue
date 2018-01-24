<template>
  <div>
    Component BlockDetails!
    <q-tabs>
      <!-- Tabs - notice slot="title" -->
      <q-tab slot="title" name="tab-1" label="message" />
      <q-tab slot="title" name="tab-2" label="fingerprint" />
      <q-tab slot="title" name="tab-3" label="account_box" />
      <q-tab slot="title" name="tab-4" label="accessibility" />
      <q-tab slot="title" name="tab-5" label="build" />
      <!-- Targets -->
      <q-tab-pane name="tab-1">Tab One</q-tab-pane>
      <q-tab-pane name="tab-2">Tab Two</q-tab-pane>
      <q-tab-pane name="tab-3">Tab Three</q-tab-pane>
      <q-tab-pane name="tab-4">Tab Four</q-tab-pane>
      <q-tab-pane name="tab-5">Tab Five</q-tab-pane>
    </q-tabs>
  </div>
</template>

<script type="text/javascript">
import { QSideLink, QTabs, QTabPane, QTab } from 'quasar';

export default {
  name: 'dashboard',
  components: {
    QSideLink,
    QTabs,
    QTabPane,
    QTab
  },
  data: function () {
    return {
      selectedTab: 'tab-2'
    }
  },
  props: [
    'block'
  ],
  computed: {
  },
  methods: {
  },
  mounted() {
  },
  beforeDestroy() {
  }
}  
</script>

<style lang="stylus">
</style>