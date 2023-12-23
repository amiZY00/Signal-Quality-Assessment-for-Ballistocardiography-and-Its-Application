import Vue from 'vue'
import Router from 'vue-router'
import Home from '../components/Home'
import Quality from "../components/Quality";
import Deal from "../components/Deal";
import HomeChart from "../components/HomeChart";
import Signal18 from "../components/Signal18";

Vue.use(Router)

export default new Router({
  mode:'history',
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home,
      children:[
        {
          path:'/detect',
          name:'detect',
          component:HomeChart,
        },
        {
          path:'/assess',
          name:'assess',
          component:Quality,
        },
        {
          path:'/deal',
          name:'deal',
          component: Deal,
        },
        {
          path: '/signal18',
          name: 'signal18',
          component: Signal18
        }
      ]
    },
  ]
})
