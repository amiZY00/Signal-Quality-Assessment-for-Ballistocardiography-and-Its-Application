package com.dhu.edu.controller;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import assessQuality.AssessQuality;
import com.csvreader.CsvReader;
import com.dhu.edu.entity.QualityInfo;
import com.dhu.edu.service.TestService;
import com.mathworks.toolbox.javabuilder.MWClassID;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import dealAnomaly.DealAnomaly;
import findAnomaly.FindAnomaly;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.rsocket.context.LocalRSocketServerPort;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.context.annotation.RequestScope;
import test.Add;

@RestController
@RequestMapping("api")
public class MainController {
//    public static List<Integer> list;
//    public static MWNumericArray S;
//    public static MWNumericArray isAnomaly_;
//    static {
//        try{
//            isAnomaly_=null;
//            list=new ArrayList<>();
//            CsvReader csvReader = new CsvReader("F:/demo.csv", ',', Charset.forName("UTF-8"));
//            csvReader.readRecord();
//            int length = csvReader.getColumnCount();
//            for (int i = 0; i < length; ++i) list.add(Integer.valueOf(csvReader.get(i)));
//            S = new MWNumericArray(list.toArray(), MWClassID.DOUBLE);
//        }catch(Exception e){
//            System.out.println(e);
//        };
//    }

    @Autowired
    TestService testService;

//    @CrossOrigin
//    @ResponseBody
//    @RequestMapping("/original")
//    public List<Integer> original() {
//        return list;
//    }

    @CrossOrigin
    @ResponseBody
    @RequestMapping("/findAnomaly")
    public int[][] findAnomaly(@RequestParam("id") int id){
        System.out.println("in findAnomaly");
        int[][] result=new int[2][];
        try{
            List<Integer> original=testService.getS("S"+id,new ArrayList<>());
            List<Integer> isAnomaly=testService.getS("anomaly"+id,new ArrayList<>());
            result[0]=new int[original.size()];
            result[1]=new int[original.size()];
            for(int i=0;i<original.size();++i){
                result[0][i]=original.get(i);
                result[1][i]=isAnomaly.get(i);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return result;
    }
    @CrossOrigin
    @ResponseBody
    @RequestMapping("/assessQuality")
    public QualityInfo assessQuality(@RequestParam(value = "datas") int[] datas,@RequestParam(value = "id") int id){
        System.out.println("in assessQuality");
        MWNumericArray original = new MWNumericArray(datas, MWClassID.DOUBLE);
        QualityInfo result=null;
        try{
            FindAnomaly find = new FindAnomaly();
            int wwidth=Double.valueOf(Math.floor(datas.length/2)).intValue();
            int lag=Double.valueOf(Math.ceil(wwidth/10)).intValue();

            System.out.println(wwidth);
            System.out.println(lag);

            Object[] anomaly_result = find.findAnomaly(3, original, wwidth, lag);
            MWNumericArray isAnomaly = (MWNumericArray) anomaly_result[0];

            AssessQuality assess = new AssessQuality();
            Object[] assess_result = assess.assessQuality(4, isAnomaly, original);
            MWNumericArray data=(MWNumericArray)assess_result[0];
            double AR=data.getDoubleData()[0];
            data=(MWNumericArray)assess_result[1];
            double ARN=data.getDoubleData()[0];
            data=(MWNumericArray)assess_result[2];
            double AALN=data.getDoubleData()[0];
            data=(MWNumericArray)assess_result[3];
            double AER=data.getDoubleData()[0];
            result=new QualityInfo(AR,ARN,AALN,AER);

            //设置缓存
            List<Integer> list_S=new ArrayList<>();
            for(int i=0;i<datas.length;++i){
                list_S.add(datas[i]);
            }
            testService.setS("S"+id,list_S);

            int[] isAnomaly_=isAnomaly.getIntData();
            List<Integer> list_anomaly=new ArrayList<>();
            for(int i=0;i<isAnomaly_.length;++i){list_anomaly.add(isAnomaly_[i]);}
            testService.setS("anomaly"+id,list_anomaly);

        }catch(Exception e){
            System.out.println(e);
        }
        return result;
    }

    @CrossOrigin
    @ResponseBody
    @RequestMapping("/dealAnomaly")
    public int[][] dealAnomaly(@RequestParam("id")int id){
        System.out.println("in dealAnomaly");
        int[][] result=null;
        try {
            List<Integer> S_=testService.getS("S"+id,new ArrayList<>());
            List<Integer> isAnomaly_=testService.getS("anomaly"+id,new ArrayList<>());
            MWNumericArray S=new MWNumericArray(S_.toArray(),MWClassID.DOUBLE);
            MWNumericArray isAnomaly=new MWNumericArray(isAnomaly_.toArray(),MWClassID.DOUBLE);

            DealAnomaly deal = new DealAnomaly();
            Object[] deal_result = deal.dealAnomaly(4, S, isAnomaly);
            MWNumericArray result_heart = (MWNumericArray) deal_result[0];
            MWNumericArray result_breath = (MWNumericArray) deal_result[1];
            MWNumericArray tmp_heart=(MWNumericArray)deal_result[2];
            MWNumericArray tmp_breath=(MWNumericArray)deal_result[3];
            result=new int[4][];
            result[0]=result_heart.getIntData();
            result[1]=result_breath.getIntData();
            result[2]=tmp_heart.getIntData();
            result[3]=tmp_breath.getIntData();
        }catch (Exception e){
            System.out.println(e);
        }
        return result;
    }
//
//    @CrossOrigin
//    @ResponseBody
//    @RequestMapping("/test")
//    public List<Integer> test(){
//        List<Integer> result;
//        testService.setS("1",list);
//        result=testService.getS("1",new ArrayList<>());
//        return result;
//    }
}
