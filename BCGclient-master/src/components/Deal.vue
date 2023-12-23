<template>
  <div class="mainBox">
        <el-row :gutter="20" style="margin-top: 25px">
          <el-col :span="15" align="left"><div id="heart" style="width: 800px;height: 300px;"></div></el-col>

          <el-col :span="9" align="center"><div id="tmp_heart" style="width: 400px;height: 300px"></div></el-col>
        </el-row>

        <el-row :gutter="20" style="margin-top: 25px">
          <el-col :span="15" align="left"><div id="breath" style="width: 800px;height: 300px" ></div></el-col>

          <el-col :span="9" align="center"><div id="tmp_breath" style="width: 400px;height: 300px"></div></el-col>

        </el-row>
  </div>
</template>


<script>
  export default {
    name: "Deal",
    mounted() {
      this.dealAnomaly();
    },
    methods: {
      dealAnomaly(){
        let currentRow=JSON.parse(sessionStorage.getItem('currentRow2'));
        if(currentRow==null)return;
        else{
          var heart=this.$echarts.init(document.getElementById('heart'));
          var breath=this.$echarts.init(document.getElementById('breath'));
          var tmp_heart=this.$echarts.init(document.getElementById('tmp_heart'));
          var tmp_breath=this.$echarts.init(document.getElementById('tmp_breath'));
          var option={
            tooltip: {
              trigger: 'axis',
              position: function (pt) {
                return [pt[0], '10%'];
              }
            },
            title: {
              left: 'center',
              text: 'BCG signal'
            },
            toolbox: {
              feature: {
                dataZoom: {
                  yAxisIndex: 'none'
                },
                restore: {},
                saveAsImage: {}
              }
            },
            xAxis: {
              type: 'value',
              boundaryGap: false
            },
            yAxis: {
              type: 'value',
            },
            series: [
              {
                name: 'BCG',
                type: 'line',
                smooth: true,
                symbol: 'none',
                data: []//data
              }
            ]
          };
          option && heart.setOption(option);
          option && breath.setOption(option);
          option && tmp_breath.setOption(option);
          option && tmp_heart.setOption(option);
          heart.showLoading();
          breath.showLoading();
          tmp_heart.showLoading();
          tmp_breath.showLoading();

          let isChanged_=JSON.parse(sessionStorage.getItem('isChanged_'));
          if(isChanged_=='1'){
            console.log(currentRow.id);
            sessionStorage.setItem('isChanged_',JSON.stringify('0'));
            this.$axios.get('/dealAnomaly?id='+currentRow.id).then(response=>{
              let data_heart=[[0,response.data[0][0]]];
              for(let i=1;i<response.data[0].length;++i){
                data_heart.push([i,response.data[0][i]]);
              }
              let data_breath=[[0,response.data[1][0]]];
              for(let i=1;i<response.data[1].length;++i){
                data_breath.push([i,response.data[1][i]]);
              }
              let data_tmp_heart=[[0,response.data[2][0]]];
              for(let i=1;i<response.data[2].length;++i){
                data_tmp_heart.push([i,response.data[2][i]]);
              }
              let data_tmp_breath=[[0,response.data[3][0]]];
              for(let i=1;i<response.data[3].length;++i){
                data_tmp_breath.push([i,response.data[3][i]]);
              }
              sessionStorage.setItem('data_heart',JSON.stringify(data_heart));
              sessionStorage.setItem('data_breath',JSON.stringify(data_breath));
              sessionStorage.setItem('data_tmp_heart',JSON.stringify(data_tmp_heart));
              sessionStorage.setItem('data_tmp_breath',JSON.stringify(data_tmp_breath));

              heart.hideLoading();
              breath.hideLoading();
              tmp_breath.hideLoading();
              tmp_heart.hideLoading();

              heart.setOption({
                title: {
                  left: 'center',
                  text: 'Fixed Heart'
                },
                series: [
                  {
                    name: 'Amplitude',
                    type: 'line',
                    smooth: true,
                    symbol: 'none',
                    data: data_heart
                  }
                ]
              });
              breath.setOption({
                title: {
                  left: 'center',
                  text: 'Fixed Breath'
                },
                series: [
                  {
                    name: 'Amplitude',
                    type: 'line',
                    smooth: true,
                    symbol: 'none',
                    data: data_breath
                  }
                ]
              });
              tmp_heart.setOption({
                title: {
                  left: 'center',
                  text: 'Heart Template'
                },
                series: [
                  {
                    name: 'Amplitude',
                    type: 'line',
                    smooth: true,
                    symbol: 'none',
                    data: data_tmp_heart
                  }
                ]
              });
              tmp_breath.setOption({
                title: {
                  left: 'center',
                  text: 'Breath Template'
                },
                series: [
                  {
                    name: 'Amplitude',
                    type: 'line',
                    smooth: true,
                    symbol: 'none',
                    data: data_tmp_breath
                  }
                ]
              })
            })
          }else{
            let data_heart=JSON.parse(sessionStorage.getItem('data_heart'));
            let data_breath=JSON.parse(sessionStorage.getItem('data_breath'));
            let data_tmp_heart=JSON.parse(sessionStorage.getItem('data_tmp_heart'));
            let data_tmp_breath=JSON.parse(sessionStorage.getItem('data_tmp_breath'));

            heart.hideLoading();
            breath.hideLoading();
            tmp_heart.hideLoading();
            tmp_breath.hideLoading();

            heart.setOption({
              title: {
                left: 'center',
                text: 'Fixed Heart'
              },
              series: [
                {
                  name: 'Amplitude',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: data_heart
                }
              ]
            });
            breath.setOption({
              title: {
                left: 'center',
                text: 'Fixed Breath'
              },
              series: [
                {
                  name: 'Amplitude',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: data_breath
                }
              ]
            });
            tmp_heart.setOption({
              title: {
                left: 'center',
                text: 'Heart Template'
              },
              series: [
                {
                  name: 'Amplitude',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: data_tmp_heart
                }
              ]
            });
            tmp_breath.setOption({
              title: {
                left: 'center',
                text: 'Breath Template'
              },
              series: [
                {
                  name: 'Amplitude',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: data_tmp_breath
                }
              ]
            })
          }
        }
      },
    },
  };
</script>


<style scoped>
  h1,
  h2 {
    font-weight: normal;
  }
  ul {
    list-style-type: none;
    padding: 0;
  }
  li {
    display: inline-block;
    margin: 0 10px;
  }
  a {
    color: #42b983;
    text-decoration: none;
  }
  body {
    margin: 0;
    padding: 0;
  }
  img {
    width: 100%;
    top: 100%;
  }
  .box-card{
    width:300px;
    height: 300px;
    transition: .1s;
  }
  .box-card:hover{
    margin-top: -5px;
  }
</style>
