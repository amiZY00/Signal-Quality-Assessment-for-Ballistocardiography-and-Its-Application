function [isAnomaly,heart,breath]=findAnomaly(S,wwidth,lag)
%S��ԭʼ�ź�
%filter_param:�˲���������8��n���󣬴��ϵ���ÿһ�зֱ�Ϊbz_1,az_1,bz_2,az_2,bz_3,az_3,bz_4,az_4
%wwidth��MDESG�㷨�Ĵ��ڿ��
%lag��MDESG�㷨�Ĳ���
[rows,columns]=size(S);
if rows~=1
    fprintf('[ERROR] S contains not only 1 line');
end
assert(rows==1);

bz_1=([9.14567820067269e-05,5.32907051820075e-15,-0.000914567820089474,1.13686837721616e-13,0.00411555519008289,2.27373675443232e-13,-0.0109748138399937,-2.27373675443232e-12,0.0192059242272080,-7.27595761418343e-12,-0.0230471090594619,-4.32009983342141e-12,0.0192059242243658,-2.16004991671070e-12,-0.0109748138393257,-8.24229573481716e-13,0.00411555519061757,-7.59392548843607e-14,-0.000914567820058609,-7.28583859910259e-17,9.14567820067115e-05]);
az_1=([1,-11.2456642412056,61.1345837854423,-214.257863473197,544.265215460494,-1067.08725939241,1677.27642988271,-2165.47278688454,2332.59992270362,-2116.88209091966,1627.09080603414,-1060.84446542317,585.552048567187,-272.090872694227,105.389086651127,-33.5025344039807,8.53710161591325,-1.68104008816452,0.240739030851484,-0.0223711705691295,0.00101554881036575]);
bz_3=([2.30926389122033e-14,2.32702745961433e-13,1.01607611213694e-12,2.88480350718601e-12,4.63273863715585e-12,6.13908923696727e-12,4.63273863715585e-12,2.92743607133161e-12,9.76996261670138e-13,2.44249065417534e-13,2.16493489801906e-14]);
az_3=([1,-9.43091838485837,40.0394157497370,-100.772504713630,166.504991707157,-188.718522275565,148.592044616937,-80.2552608421316,28.4558818904429,-5.98102612430015,0.565898376234651]);

heart=filtHB(S,bz_1,az_1);%�����ź�
breath=filtHB(S,bz_3,az_3);%�����ź�

assert(length(S)>wwidth);
assert(wwidth>lag);
len_S=length(S);
[frames,voteResults,voteRatio,isAnomaly,anomalyLength]=calcMDESGAnomaly(S,wwidth,lag);%ʹ��MDESG����쳣
[available_normal,anomalyLength,isAnomaly]=findAvailableNormal(isAnomaly);%�ҵ���������

for k=1:length(available_normal(1,:))
    BR_seg_length=available_normal(2,k)-available_normal(1,k)+1;
    [BR_seg_isAnomaly]=calcSRAnomaly(breath(available_normal(1,k):available_normal(2,k)));%����������ĺ��������м��SR�쳣
    for t=1:BR_seg_length
        if BR_seg_isAnomaly(t)==1
            temp_loc=available_normal(1,k)+t-1;
            if temp_loc>50
                if len_S-temp_loc>=50
                    isAnomaly(temp_loc-50:temp_loc+50)=1;
                else
                    isAnomaly(temp_loc-50:end)=1;
                end
            else
                if len_S-temp_loc>=50
                    isAnomaly(1:temp_loc+50)=1;
                else
                    isAnomaly(1:end)=1;
                end
            end
        end
    end
end

[anomalyLength]=cntAnomalyLength(isAnomaly);
[isAnomaly]=mergeAnomaly(isAnomaly,anomalyLength);
end