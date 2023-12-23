package com.dhu.edu.entity;

import lombok.ToString;

@ToString
public class QualityInfo {
    public QualityInfo(double ar,double arn,double aaln,double aer){
        this.ar=ar;
        this.arn=arn;
        this.aaln=aaln;
        this.aer=aer;
    }
    private double ar;
    private double arn;
    private double aaln;
    private double aer;
    public void setAr(double ar){this.ar=ar;}
    public double getAr(){return ar;}
    public void setArn(double arn){this.arn=arn;}
    public double getArn(){return arn;}
    public void setAaln(double aaln){this.aaln=aaln;}
    public double getAaln(){return aaln;}
    public void setAer(double aer){this.aer=aer;}
    public double getAer(){return aer;}
}
