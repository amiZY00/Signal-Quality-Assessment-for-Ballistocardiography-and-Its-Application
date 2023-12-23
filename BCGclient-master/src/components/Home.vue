<template>
  <div class="homePage">

    <el-menu
      :default-active="activeIndex2"
      class="el-menu-demo"
      mode="horizontal"
      @select="handleSelect"
      background-color="#545c64"
      text-color="#fff"
      active-text-color="#ffd04b">
      <router-link to="/assess">
        <el-menu-item index="1">Home</el-menu-item>
      </router-link>
      <router-link to="/detect">
        <el-menu-item index="2">异常检测</el-menu-item>
      </router-link>
      <router-link to="/deal">
        <el-menu-item index="3">异常处理</el-menu-item>
      </router-link>
    </el-menu>
      <el-main>
        <router-view></router-view>
      </el-main>


  </div>
</template>

<script>
export default {
  name: "Home",
  data(){
      return{
        activeIndex2:'1'
      };
  },
  mounted() {
    this.init();
  },
  methods: {
    init(){
      this.$router.replace({path:'/assess'})
    },
    handleSelect(key,keyPath){
      this.activeIndex2=key;
    }
  },
};
</script>

<style scoped>
body {
  margin: 0;
  padding: 0;
}
a {
  text-decoration: none;
}
.homePage {
  display: flex;
  border: 1px solid #eee;
  margin: 0;
  min-height: 750px;
}
.leftContainer {
}
.rightContainer {
  background-color: #eeeeee;
}

.rightContainer .headerContainer {
  text-align: right;
  font-size: 12px;
  height: 65px;
  vertical-align: middle;
}
img {
  width: 100%;
  top: 100%;
}
</style>
