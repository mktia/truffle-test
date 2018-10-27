import Vue from 'vue'
import Router from 'vue-router'
import Offline from '@/components/Offline'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Offline',
      component: Offline
    }
  ]
})
