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
        <el-upload class="upload-csv" :auto-upload="false" :on-change="openFile" accept=".csv">
          <el-button size="small" type="primary">点击上传</el-button>
          <div slot="tip" class="el-upload__tip">只能上传csv文件</div>
        </el-upload>
      </el-badge>
    </el-header>

    <el-row :gutter="0" type="flex" justify="center" class="margin-top:16px">
      <el-col :span="12"><div id="signal1" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal2" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal3" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal4" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal5" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal6" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal7" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal8" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal9" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal10" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal11" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal12" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal13" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal14" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal15" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal16" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
    <el-row :gutter="0" type="flex" justify="center">
      <el-col :span="12"><div id="signal17" style="width: 750px;height: 300px;"></div></el-col>
      <el-col :span="12"><div id="signal18" style="width: 750px;height: 300px;"></div></el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "Signal18",
    mounted() {
      this.initChart();
    },
    methods:{
      initChart(){
        var original_;
        var original;
        var myCharts=[];
        for(let i=1;i<=18;++i){
          original_ = document.getElementById('signal'+i);
          original = this.$echarts.init(original_);
          myCharts.push(original);
          let option = {
            title: {
              left: 'center',
              text: 'Sensor'+i
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
                name: 'sensor '+i,
                type: 'line',
                smooth: true,
                symbol: 'none',
                data: []//data
              }
            ]
          };
          option && original.setOption(option);
        }
        this.myCharts=myCharts;
      },
      openFile(file) {
        this.$Papa.parse(file.raw, {
          encoding: "ANSI",
          complete: res => {
            // UTF8 \r\n与\n混用时有可能会出问题
            let data = res.data;
            if (data[data.length - 1] == "") {
              //去除最后的空行
              data.pop();
            }
            // console.log(data);
            var myCharts=this.myCharts;
            // console.log(myCharts);
            for(let i=0;i<18;++i){
              // console.log(data[i]);
              var temp_data=[[0,data[i][0]]];
              for(let j=1;j<data[i].length;++j){
                temp_data.push([j,data[i][j]]);
              }
              myCharts[i].setOption({
                series:[{
                  name: 'BCG',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: temp_data
                }]
              })
            }
            console.log(data);
            // var list=[];
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
                sessionStorage.setItem('assessResult'+i+1,JSON.stringify(temp_));
              })
            }
          }
        })
      }
    }
  }
</script>
