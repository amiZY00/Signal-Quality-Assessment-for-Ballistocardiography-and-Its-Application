// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import * as echarts from 'echarts'
import Papa from 'papaparse'
import axios from "axios";
import qs from 'qs'

axios.defaults.baseURL = 'http://localhost:8082/api'
Vue.prototype.$axios = axios
Vue.prototype.$echarts=echarts
Vue.prototype.$Papa=Papa
Vue.prototype.qs=qs
Vue.config.productionTip = false
/* eslint-disable no-new */
Vue.use(ElementUI)
new Vue({
  el: '#app',
  router,
  render: h => h(App),
  components: { App },
  template: '<App/>'
})
