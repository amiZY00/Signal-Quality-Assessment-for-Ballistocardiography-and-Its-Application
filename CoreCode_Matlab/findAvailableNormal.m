function [available_normal,anomalyLength,isAnomaly]=findAvailableNormal(isAnomaly)
%扩展异常点，提取并合并异常区间，找到可用来提取模板信号的正常区间
%available_normal：存储正常区间范围的矩阵。第一行表示左边界下标，第二行表示右边界下标

len_S=length(isAnomaly);
%基于异常区间周围的点有很大概率也是异常点这一先验知识，将异常区间向左右再延伸100个点
[anomalyLength]=cntAnomalyLength(isAnomaly);
anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
len_anomalyLength=length(anomalyLength(1,:));
for k=1:len_anomalyLength
    if anomalyLength(1,k)>300
        isAnomaly(anomalyLength(1,k)-100:anomalyLength(1,k)-1)=1;
    else
        isAnomaly(1:anomalyLength(1,k)-1)=1;
    end
    if len_S-anomalyLength(1,k)-anomalyLength(2,k)+1>300
        temp_start=anomalyLength(1,k)+anomalyLength(2,k);
        isAnomaly(temp_start:temp_start+99)=1;
    else
        isAnomaly(anomalyLength(1,k)+anomalyLength(2,k):len_S)=1;
    end
end

[anomalyLength]=cntAnomalyLength(isAnomaly);
anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
[isAnomaly]=mergeAnomaly(isAnomaly,anomalyLength);%合并异常区间
%再次寻找异常区间
[anomalyLength]=cntAnomalyLength(isAnomaly);
anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
len_anomalyLength=length(anomalyLength(1,:));
%寻找能用来提取模板信号的正常区间
available_normal=zeros(2,len_anomalyLength+1);
if len_anomalyLength==0
    fprintf("[Warning] no outlier, no need to find available normal interval");
    available_normal(1,1)=1;
    available_normal(2,1)=len_S;
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
end