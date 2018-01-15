<template>
  <div class="container row justify-center">
    <div class="message text-primary">Node {{ currentNode.ip }} </div>
    <div style="width: 100%"/>
    <svg class="svgNode bg-primary fixed-center" id="svg1" width="100%" height="600">
    </svg>
  </div>
</template>

<script type="text/javascript">

export default {
  name: "main-blockchain",
  data: function() {
    return {
      blockchain: true,
      currentNode: this.$store.state.selectedNode,
      timer: null
    }
  },
  methods: {
    refreshData: function () {
      this.$http.get('https://httpbin.org/get').then(response =>
      {
        console.log("Refreshed! " + this.currentNode.ip);
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
  .message
    font-size 2.5em

  .svgNode
    width: 70%
    border 1px solid black
    opacity 0.98
</style>