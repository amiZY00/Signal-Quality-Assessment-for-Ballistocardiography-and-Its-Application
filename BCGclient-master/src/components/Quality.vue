<template>
  <div class="mainBox">
    <el-header
      class="headerContainer"
      style="background-color: rgba(90, 224, 224, 0.44)"
    >
      <el-badge
        :max="10"
        class="item"
        style="margin-top: 10px; margin-right: 20px"
      >
        <el-upload class="upload-csv" :auto-upload="false" :on-change="assessQuality" accept=".csv">
          <el-button :loading="isLoading" type="primary" round class="el-icon-moon-night">点击选择文件</el-button>
        </el-upload>
      </el-badge>
    </el-header>
    <el-table
      :data="qualityIndex"
      style="width: 100%">
      <el-table-column
        prop="id"
        label="传感器编号"
        align="center"
        sortable
      >
      </el-table-column>
      <el-table-column
        prop="ar"
        label="异常数据比例(AR)"
        align="center"
        sortable
        :formatter="rounding"
        >
      </el-table-column>
      <el-table-column
        prop="arn"
        label="异常区间数目(ARN)"
        align="center"
        sortable
        >
      </el-table-column>
      <el-table-column
        prop="aaln"
        label="平均异常区间间距(AALN)"
        align="center"
        sortable
        :formatter="rounding"
        >
      </el-table-column>
      <el-table-column
        prop="aer"
        label="心率信号能量占比(AER)"
        align="center"
        sortable
        :formatter="rounding"
        >
      </el-table-column>
      <el-table-column
        prop="score"
        label="质量评分"
        align="center"
        sortable
        :formatter="rounding"
      >
      </el-table-column>
      <el-table-column
        fixed="right"
        label="操作"
        align="center"
        width="100">
        <template slot-scope="scope">
          <el-button @click="handleClick(scope.row)" type="text" size="small">查看</el-button>
          <el-button @click="handleClick2(scope.row)" type="text" size="small">处理</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>


<script>
  export default {
    name: "Quality",
    mounted() {
      this.fillTable();
    },
    data(){
      return{
        qualityIndex:[],
        isLoading:false
      }
    },
    methods: {
      Filted() {
        var heart_ = document.getElementById('heart');
        var breath_ = document.getElementById('breath');
        var breath = this.$echarts.init(breath_);
        var heart = this.$echarts.init(heart_);
        heart.showLoading();
        breath.showLoading();

        let data_heart=JSON.parse(sessionStorage.getItem('heart'));
        let data_breath=JSON.parse(sessionStorage.getItem('breath'));
        var option1;
        option1 = {
          tooltip: {
            trigger: 'axis',
            position: function (pt) {
              return [pt[0], '10%'];
            }
          },
          title: {
            left: 'center',
            text: 'Heart'
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
            // boundaryGap: [0, '100%']
          },
          // dataZoom: [
          //   {
          //     type: 'inside',
          //     start: 0,
          //     end: 20
          //   },
          //   {
          //     start: 0,
          //     end: 20
          //   }
          // ],
          series: [
            {
              name:'heart',
              type: 'line',
              smooth: true,
              symbol: 'none',
              data: data_heart,
            }
          ]
        };
        var option2;
        option2 = {
          tooltip: {
            trigger: 'axis',
            position: function (pt) {
              return [pt[0], '10%'];
            }
          },
          title: {
            left: 'center',
            text: 'Breath'
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
            // boundaryGap: [0, '100%']
          },
          // dataZoom: [
          //   {
          //     type: 'inside',
          //     start: 0,
          //     end: 20
          //   },
          //   {
          //     start: 0,
          //     end: 20
          //   }
          // ],
          series: [
            {
              name:'breath',
              type: 'line',
              smooth: true,
              symbol: 'none',
              data: data_breath,
            }
          ]
        };

        console.log(data_heart);
        console.log(data_breath);
        heart.hideLoading();
        option1 && heart.setOption(option1);
        breath.hideLoading();
        option2 && breath.setOption(option2);
        // this.$axios({
        //   method: "get",
        //   url: "/findAnomaly"
        // }).then(response => {
        //   heart.hideLoading();
        //   let data_heart = [[0, response.data[1][0]]];
        //   for (let i = 1; i < response.data[1].length; ++i) {
        //     data_heart.push([i, response.data[1][i]]);
        //   }
        //   heart.setOption({
        //     title:{
        //       left: 'center',
        //       text: 'Heart',
        //     },
        //     series: [{
        //       name: 'Heart',
        //       type: 'line',
        //       smooth: true,
        //       symbol: 'none',
        //       data: this.heart,
        //     }]
        //   });
        //   console.log(data_heart);
        //
        //   breath.hideLoading();
        //   let data_breath = [[0, response.data[2][0]]];
        //   for (let i = 1; i < response.data[2].length; ++i) {
        //     data_breath.push([i, response.data[2][i]]);
        //   }
        //   breath.setOption({
        //     title:{
        //       left: 'center',
        //       text: 'Breath'
        //     },
        //     series: [{
        //       name: 'Breath',
        //       type: 'line',
        //       smooth: true,
        //       symbol: 'none',
        //       data: data_breath,
        //     }]
        //   });
        //   console.log(data_breath);
        // });
      },
      dealAnomaly(){
        var tmp_heart=this.$echarts.init(document.getElementById('tmp_heart'));
        var tmp_breath=this.$echarts.init(document.getElementById('tmp_breath'));
        tmp_heart.showLoading();
        tmp_breath.showLoading();
        var option;
        option = {
          tooltip: {
            trigger: 'axis',
            position: function (pt) {
              return [pt[0], '10%'];
            }
          },
          title: {
            left: 'center',
            text: 'Template'
          },
          xAxis: {
            type: 'value',
            boundaryGap: false,
            axisLine:{       //y轴
              "show":false

            },
            axisTick:{       //y轴刻度线
              "show":false
            },
            splitLine: {     //网格线
              "show": false
            },
            axisLabel: {
              show:false
            }
          },
          yAxis: {
            type: 'value',
            axisLine:{       //y轴
              "show":false

            },
            axisTick:{       //y轴刻度线
              "show":false
            },
            splitLine: {     //网格线
              "show": false
            },
            axisLabel:{
              show:false
            }
          },
          series: [
            {
              name:'temp',
              type: 'line',
              smooth: true,
              symbol: 'none',
              data: []//data
            }
          ]
        };
        option && tmp_heart.setOption(option);
        option && tmp_breath.setOption(option);
        this.$axios({
          methods:"get",
          url:"/dealAnomaly"
        }).then(response=>{
          tmp_breath.hideLoading();
          tmp_heart.hideLoading();
          let data_heart=[[0,response.data[2][0]]];
          for(let i=1;i<response.data[2].length;++i){
            data_heart.push([i,response.data[2][i]]);
          }
          let data_breath=[[0,response.data[3][0]]];
          for(let i=1;i<response.data[3].length;++i){
            data_breath.push([i,response.data[3][i]]);
          }
          tmp_heart.setOption({
            title:{
              left:'center',
              text: 'Heart Template'
            },
            series:[{
              name: 'Heart',
              type: 'line',
              smooth: true,
              symbol: 'none',
              data: data_heart
            }]
          })
          tmp_breath.setOption({
            title:{
              left:'center',
              text:'Breath template'
            },
            series:[{
              name: 'Breath',
              type: 'line',
              smooth: true,
              symbol: 'none',
              data: data_breath,
            }]
          })
        });
      },
      assessQuality(file){
        this.qualityIndex=undefined;
        this.qualityIndex=new Array();
        sessionStorage.clear();

        console.log('loading data...');
        this.isLoading=true;
        this.$Papa.parse(file.raw, {
          encoding: "ANSI",
          complete: res => {
            // UTF8 \r\n与\n混用时有可能会出问题
            let data = res.data;
            if (data[data.length - 1] == "") {
              //去除最后的空行
              data.pop();
            }

            for(let i=0;i<18;++i){
              this.$axios.post('/assessQuality',this.qs.stringify({
                  datas:data[i],
                  id:i+1
                },
                {
                  indices:false
                }
                )
              ).then(response=>{
                console.log('sensor '+(i+1)+' success');
                let temp_=response.data;
                temp_.id=i+1;

                console.log(temp_);
                this.qualityIndex.push(temp_);
                sessionStorage.setItem('assessResult'+(i+1),JSON.stringify(temp_));
                let flag=1;
                for(let j=1;j<=18;++j){
                  if(sessionStorage.getItem('assessResult'+j)==null)flag=0;
                }
                if(flag==1){
                  let total=this.qualityIndex;
                  console.log(total.length)
                  let max_ar=-1;
                  let min_ar=10000;
                  let max_arn=-1;
                  let min_arn=10000;
                  let max_aaln=-1;
                  let min_aaln=10000;
                  let max_aer=-1;
                  let min_aer=10000;

                  for(let j=0;j<total.length;++j){
                    if(total[j].ar>max_ar)max_ar=total[j].ar;
                    if(total[j].ar<min_ar)min_ar=total[j].ar;

                    if(total[j].arn>max_arn)max_arn=total[j].arn;
                    if(total[j].arn<min_arn)min_arn=total[j].arn;

                    if(total[j].aaln>max_aaln)max_aaln=total[j].aaln;
                    if(total[j].aaln<min_aaln)min_aaln=total[j].aaln;

                    if(total[j].aer>max_aer)max_aer=total[j].aer;
                    if(total[j].aer<min_aer)min_aer=total[j].aer;
                  }
                  // console.log(max_ar);
                  // console.log(min_ar);
                  // console.log(max_arn);
                  // console.log(min_arn);
                  // console.log(max_aaln);
                  // console.log(min_aaln);
                  // console.log(max_aer);
                  // console.log(min_aer);
                  for(let j=0;j<total.length;++j){
                    let nor_ar=(max_ar-total[j].ar)/(max_ar-min_ar);
                    let nor_arn=(max_arn-total[j].arn)/(max_arn-min_arn);
                    let nor_aaln=(max_aaln-total[j].aaln)/(max_aaln-min_aaln);
                    let nor_aer=(total[j].aer-min_aer)/(max_aer-min_aer);
                    total[j].score=2*nor_aer+1.5*nor_ar+1*nor_arn+0.5*nor_aaln;
                  }

                  total.sort(function (a,b) {
                    return a.id-b.id;
                  })
                  this.qualityIndex=undefined;
                  this.qualityIndex=new Array();
                  for(let j=0;j<total.length;++j){
                    this.qualityIndex.push(total[j]);
                  }
                  this.isLoading=false;
                  for(let j=1;j<=18;++j){
                    sessionStorage.setItem('assessResult'+j,JSON.stringify(total[j-1]));
                  }
                  console.log(total);

                }
              })
            }
          }
        })
      },
      rounding(row,column) {
        return parseFloat(row[column.property]).toFixed(4)
      },
      fillTable(){
        console.log('in fillTable');
        if(sessionStorage.getItem('assessResult1')!=null){
          for(let i=1;i<=18;++i){
            let temp_=JSON.parse(sessionStorage.getItem('assessResult'+i));
            if(temp_!=null){
              this.qualityIndex.push(temp_);
            }
          }
        }
      },
      handleClick(row) {
        console.log(row);
        sessionStorage.setItem('currentRow',JSON.stringify(row));
        sessionStorage.setItem('isChanged',JSON.stringify('1'));
        this.$router.replace({path:'/detect'});
      },
      handleClick2(row){
        console.log(row);
        sessionStorage.setItem('currentRow2',JSON.stringify(row));
        sessionStorage.setItem('isChanged_',JSON.stringify('1'));
        this.$router.replace({path:'/deal'});
      }
    }
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
