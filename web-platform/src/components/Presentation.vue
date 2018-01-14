<template>
  <div class="welcome-message-container fixed-center">
    <q-carousel ref="carousel" infinite :autoplay="2000" :animation="700" arrows dots class="text-white carousel">
      <div slot="slide" class="bg-primary centered slide">
        Explore your Private Blochain
      </div>
      <div slot="slide" class="bg-grey-7 centered slide">
        Configure Attacks
      </div>
      <div slot="slide" class="bg-tertiary centered slide">
        Real Time Visualization
      </div>
    </q-carousel>
  </div>
</template>

<script type="text/javascript">
  import { QCarousel } from 'quasar'

  export default {
    name: 'presentation',
    components: {
      QCarousel
    }
  }

</script>

<style lang="stylus">
.welcome-message-container
  width 100%
  height: 400px
  text-align centered

.slide
  font-size 2.5em

</style>