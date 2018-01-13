<template>
  <q-layout ref="layout" view="HHH Lpr fff" :left-class="{'bg-grey-2': true}">
    <q-toolbar slot="header" class="glossy">
      <q-btn flat @click="$refs.layout.toggleLeft()">
        <q-icon name="menu" />
      </q-btn>

      <q-toolbar-title>
        Ethereum Blockchain Attack Visualizer
        <div slot="subtitle">Supelec SIS Project</div>
      </q-toolbar-title>
    </q-toolbar>

    <div slot="left">
      <q-list-header>Menu</q-list-header>
      <div @click="$refs.layout.hideLeft()">
        <q-side-link item to="/" exact>
          <q-item-side icon="home" />
          <q-item-main label="Home" sublabel="Go Back to the Home Page" />
        </q-side-link>
        <q-side-link item to="/network">
          <q-item-side icon="dns" />
          <q-item-main label="Network" sublabel="Visualize Architecture" />
        </q-side-link>
      </div>
    </div>

    <router-view/>

    <q-toolbar slot="footer">
      <q-toolbar-title>
        <div class="row justify-between">
          <div>Supelec</div>
          <div>2017/2018</div>
        </div>
      </q-toolbar-title>
    </q-toolbar>
  </q-layout>

</template>

<script>
import {
  QSideLink,
  openURL,
  QLayout,
  QToolbar,
  QToolbarTitle,
  QBtn,
  QIcon,
  QList,
  QListHeader,
  QItem,
  QItemSide,
  QItemMain
} from 'quasar'

export default {
  name: 'dashboard',
  components: {
    QSideLink,
    QLayout,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon,
    QList,
    QListHeader,
    QItem,
    QItemSide,
    QItemMain
  },

  data: function () {
    return {
    }
  },
  computed: {
  },
  methods: {
    launch(url) {
      openURL(url)
    }
  },
  mounted() {
    this.$refs.layout.toggleLeft();
  },
  beforeDestroy() {
  }
}
</script>