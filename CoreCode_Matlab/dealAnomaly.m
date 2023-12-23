function [result_heart,result_breath,tmp_heart,tmp_breath]=dealAnomaly(S,isAnomaly)
%处理异常值
%heart：原始BCG信号滤波得到的心率信号
%breath：呼吸信号
%isAnomaly：经过异常区间扩展和融合异常标签
bz_1=[9.14567820067269e-05,5.32907051820075e-15,-0.000914567820089474,1.13686837721616e-13,0.00411555519008289,2.27373675443232e-13,-0.0109748138399937,-2.27373675443232e-12,0.0192059242272080,-7.27595761418343e-12,-0.0230471090594619,-4.32009983342141e-12,0.0192059242243658,-2.16004991671070e-12,-0.0109748138393257,-8.24229573481716e-13,0.00411555519061757,-7.59392548843607e-14,-0.000914567820058609,-7.28583859910259e-17,9.14567820067115e-05];
az_1=[1,-11.2456642412056,61.1345837854423,-214.257863473197,544.265215460494,-1067.08725939241,1677.27642988271,-2165.47278688454,2332.59992270362,-2116.88209091966,1627.09080603414,-1060.84446542317,585.552048567187,-272.090872694227,105.389086651127,-33.5025344039807,8.53710161591325,-1.68104008816452,0.240739030851484,-0.0223711705691295,0.00101554881036575];
bz_2=[5.12472844160783e-08,3.58730988914147e-07,1.07619298006512e-06,1.79365493124806e-06,1.79365497743333e-06,1.07619295341976e-06,3.58730997795931e-07,5.12472836389222e-08];
az_2=[1,-6.13368807968169,16.1716484654842,-23.7532440011023,20.9885087921903,-11.1549634994526,3.30143814923418,-0.419693267019662];
bz_3=[2.30926389122033e-14,2.32702745961433e-13,1.01607611213694e-12,2.88480350718601e-12,4.63273863715585e-12,6.13908923696727e-12,4.63273863715585e-12,2.92743607133161e-12,9.76996261670138e-13,2.44249065417534e-13,2.16493489801906e-14];
az_3=[1,-9.43091838485837,40.0394157497370,-100.772504713630,166.504991707157,-188.718522275565,148.592044616937,-80.2552608421316,28.4558818904429,-5.98102612430015,0.565898376234651];
bz_4=[2.81619443320835e-08,1.40809718551793e-07,2.81619451314441e-07,2.81619431774516e-07,1.40809729209934e-07,2.81619425557267e-08];
az_4=[1,-4.79597747410109,9.20456768503924,-8.83655725499422,4.24336984285425,-0.815401897615971];

    heart=filtHB(S,bz_1,az_1);
    breath=filtHB(S,bz_3,az_3);

    %找到正常区间
    len_S=length(isAnomaly);
    [anomalyLength]=cntAnomalyLength(isAnomaly);
    anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
    len_anomalyLength=length(anomalyLength(1,:));
    available_normal=zeros(2,len_anomalyLength+1);
    if len_anomalyLength==0
        available_normal(1,1)=1;
        available_normal(2,1)=len_S;
        result_heart=heart;
        result_breath=breath;
        return;
    end
    k=1;
    t=1;
    if anomalyLength(1,1)>1
        available_normal(1,t)=1;
        available_normal(2,t)=anomalyLength(1,1)-1;
        t=t+1;
    end
    while k<len_anomalyLength
        available_normal(1,t)=anomalyLength(1,k)+anomalyLength(2,k);
        available_normal(2,t)=anomalyLength(1,k+1)-1;
        t=t+1;
        k=k+1;
    end
    if len_S-(anomalyLength(1,len_anomalyLength)+anomalyLength(2,len_anomalyLength))+1 ~=0
        available_normal(1,t)=anomalyLength(1,len_anomalyLength)+anomalyLength(2,len_anomalyLength);
        available_normal(2,t)=len_S;
    end
    available_normal=available_normal(:,available_normal(1,:)~=0);
    if length(available_normal)==0
        fprintf('[WARNING] no available interval');
        result_heart=heart;
        result_breath=breath;
        return;
    end
    
    normalLength=diff(available_normal);
    [MAX,loc]=max(normalLength);
    [tmp_heart,filted,seg_merged,fin_loc]=calcHBTemplate(S(available_normal(1,loc):available_normal(2,loc)),bz_1,az_1);
    [result_heart]=addressAnomaly(heart,anomalyLength,tmp_heart,bz_1,az_1,bz_2,az_2);
    
    [tmp_breath,filted,seg_merged,fin_loc]=calcBRTemplate(S(available_normal(1,loc):available_normal(2,loc)),bz_3,az_3);
    [result_breath]=addressAnomaly(breath,anomalyLength,tmp_breath,bz_3,az_3,bz_4,az_4);
end