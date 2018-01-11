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
    this.$http.get('https://httpbin.org/get').then(response => {console.log(response.data)});
  },
} 
</script>

<style lang="stylus">
  
</style>