<template>
  <div class="homePage">
    <el-container class="leftContainer">
      <el-aside width="200px" style="background-color: #374355; width: 200px">
        <div
          style="
            margin-top: 20px;
            margin-bottom: 20px;
            color: #ffffff;
            text-align: center;
          "
        >
          <span class="el-icon-s-management">BCG信号处理系统 </span>
        </div>
        <hr />
        <el-menu
          style="background-color: #374355; width: 202px"
          text-color="#9BA1AA"
          active-text-color="#47A1F8"
          unique-opened
        >
          <el-submenu index="1">
            <template slot="title">
              <i class="el-icon-setting"></i>基础管理
            </template>

            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/yuangong">
                  <el-menu-item index="1-1">员工管理</el-menu-item>
                </router-link>
              </div>
            </div>
            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/bumen">
                  <el-menu-item index="1-2">部门管理</el-menu-item>
                </router-link>
              </div>
            </div>
            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/groups">
                  <el-menu-item index="1-3">小组管理</el-menu-item>
                </router-link>
              </div>
            </div>
          </el-submenu>
          <el-submenu index="2">
            <template slot="title">
              <i class="el-icon-setting"></i>变动管理
            </template>

            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/Transfer">
                  <el-menu-item index="2-1">出差统计</el-menu-item>
                </router-link>
              </div>
            </div>
            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/Resign">
                  <el-menu-item index="2-2">离职管理</el-menu-item>
                </router-link>
              </div>
            </div>
          </el-submenu>
          <el-submenu index="3">
            <template slot="title">
              <i class="el-icon-setting"></i>考勤查看
            </template>

            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/kaoqin">
                  <el-menu-item index="3-1">查看考勤记录</el-menu-item>
                </router-link>
              </div>
            </div>
          </el-submenu>

          <el-submenu index="4">
            <template slot="title">
              <i class="el-icon-setting"></i>工薪管理
            </template>

            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/tongji">
                  <el-menu-item index="4-1">工资统计</el-menu-item>
                </router-link>
              </div>
            </div>
            <div style="background-color: #1c2738">
              <div style="background-color: #011327">
                <router-link to="/orders/yeji">
                  <el-menu-item index="4-2">业绩统计</el-menu-item>
                </router-link>
              </div>
            </div>
          </el-submenu>
        </el-menu>
      </el-aside>

      <!-- 右侧 -->
      <el-container class="rightContainer">
        <!-- 顶部 -->
        <el-header
          class="headerContainer"
          style="background-color: rgba(90, 224, 224, 0.44)"
        >
          <el-badge
            :max="10"
            class="item"
            style="margin-top: 10px; margin-right: 20px"
          >
            <el-button
              type="primary"
              round
              @click="logOut"
              class="el-icon-moon-night"
            >
              注销</el-button
            >
          </el-badge>
        </el-header>

        <!-- 页面内容 -->
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
export default {
  name: "Home"
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
