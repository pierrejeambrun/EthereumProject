<template>
  <div id="container" style="background-color: white">
  <iframe id="theFrame" src="http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js" style="width:100%; height:100%" frameborder="0">
  </iframe>
  </div>
</template>

<script type="text/javascript">
export default {
  name: 'dashboard',
  components: {
  },
  data: function () {
    return {
    }
  },
  props: [
  ],
  computed: {
  },
  methods: {
  },
  mounted() {
    $("#container").css("height", $(document).height() - $("header").height() - $("footer").height());
  },
  beforeDestroy() {
  }
}  
</script>

<style lang="stylus">
div.terminal_1ywR9V
  background-color: white;
</style>