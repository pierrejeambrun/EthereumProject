<template>
  <div>Blockchain visualizers Of Node {{ currentNodeId }}</div>
</template>

<script type="text/javascript">

export default {
  name: "main-blockchain",
  data: function() {
    return {
      blockchain: true,
      currentNodeId: this.$store.state.selectedNodeId,
      timer: null
    }
  },
  methods: {
    refreshData: function () {
      this.$http.get('https://httpbin.org/get').then(response =>
      {
        console.log("Refreshed!" + this.currentNodeId);
        console.log(response.data);});
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
  
</style>