import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

function load (component) {
  // '@' is aliased to src/components
  return () => import(`@/${component}.vue`)
}

export default new VueRouter({
  mode: 'hash',
  scrollBehavior: () => ({ y: 0 }),

  routes: [
    {
      path: '/', component: load('Dashboard'),
      children: [{
          path: '',
          component: load('Presentation')}
      ]
    },
    { path: '*', component: load('Error404') }
  ]
})
