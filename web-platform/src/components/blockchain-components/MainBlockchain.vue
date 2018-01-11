<template>
  <div>Blockchain visualizers Of Node {{ currentNodeId }}</div>
</template>

<script type="text/javascript">

export default {
  name: "main-blockchain",
  data: function() {
    return {
      blockchain: true,
      currentNodeId: this.$store.state.selectedNodeId
    }
  },
  mounted: function() {
  },
} 
</script>

<style lang="stylus">
  
</style>