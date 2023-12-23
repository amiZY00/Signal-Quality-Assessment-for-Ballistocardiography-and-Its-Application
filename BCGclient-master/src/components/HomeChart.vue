<template>
  <div class="mainBox">
    <p><div id="original" style="width: 1300px; height: 300px"></div>
    <p><div id="isAnomaly" style="width: 1300px; height: 300px"></div>
  </div>
</template>

<script>
  export default {
    name: "HomeChart",
    mounted() {
      this.getChart();
    },
    methods: {
      getChart(){
        let currentRow=JSON.parse(sessionStorage.getItem('currentRow'));
        if(currentRow==null)return;
        else{
          var original_=document.getElementById('original');
          var isAnomaly_=document.getElementById('isAnomaly');
          var original=this.$echarts.init(original_);
          var isAnomaly=this.$echarts.init(isAnomaly_);
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
          option && original.setOption(option);
          option && isAnomaly.setOption(option);
          original.showLoading();
          isAnomaly.showLoading();
          let isChanged=JSON.parse(sessionStorage.getItem('isChanged'));
          if(isChanged=='1'){
            console.log(currentRow.id);
            sessionStorage.setItem('isChanged',JSON.stringify('0'));
            this.$axios.get('/findAnomaly?id='+currentRow.id).then(response=>{
              let org_signal=[[0,response.data[0][0]]];
              for(let i=1;i<response.data[0].length;++i){
                org_signal.push([i,response.data[0][i]]);
              }
              let anomaly=[[0,response.data[1][0]]];
              for(let i=1;i<response.data[1].length;++i){
                anomaly.push([i,response.data[1][i]]);
              }
              sessionStorage.setItem('org_signal',JSON.stringify(org_signal));
              sessionStorage.setItem('anomaly',JSON.stringify(anomaly));
              original.hideLoading();
              isAnomaly.hideLoading();
              original.setOption({
                title: {
                  left: 'center',
                  text: 'BCG signal'
                },
                series: [
                  {
                    name: 'BCG',
                    type: 'line',
                    smooth: true,
                    symbol: 'none',
                    data: org_signal
                  }
                ]
              });
              isAnomaly.setOption({
                title: {
                  left: 'center',
                  text: 'Anomaly Label'
                },
                series: [
                  {
                    name: 'Label',
                    type: 'line',
                    smooth: true,
                    symbol: 'none',
                    data: anomaly
                  }
                ]
              })
            })
          }else{
            let org_signal=JSON.parse(sessionStorage.getItem('org_signal'));
            let anomaly=JSON.parse(sessionStorage.getItem('anomaly'));
            console.log(org_signal);
            console.log(anomaly);
            original.hideLoading();
            isAnomaly.hideLoading();
            original.setOption({
              title: {
                left: 'center',
                text: 'BCG signal'
              },
              series: [
                {
                  name: 'BCG',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: org_signal
                }
              ]
            });
            isAnomaly.setOption({
              title: {
                left: 'center',
                text: 'Anomaly Label'
              },
              series: [
                {
                  name: 'Label',
                  type: 'line',
                  smooth: true,
                  symbol: 'none',
                  data: anomaly
                }
              ]
            })
          }
        }
      }
    },
  };
</script>
