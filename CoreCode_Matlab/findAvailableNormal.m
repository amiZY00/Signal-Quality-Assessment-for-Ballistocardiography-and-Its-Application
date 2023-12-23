function [available_normal,anomalyLength,isAnomaly]=findAvailableNormal(isAnomaly)
%��չ�쳣�㣬��ȡ���ϲ��쳣���䣬�ҵ���������ȡģ���źŵ���������
%available_normal���洢�������䷶Χ�ľ��󡣵�һ�б�ʾ��߽��±꣬�ڶ��б�ʾ�ұ߽��±�

len_S=length(isAnomaly);
%�����쳣������Χ�ĵ��кܴ����Ҳ���쳣����һ����֪ʶ�����쳣����������������100����
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
[isAnomaly]=mergeAnomaly(isAnomaly,anomalyLength);%�ϲ��쳣����
%�ٴ�Ѱ���쳣����
[anomalyLength]=cntAnomalyLength(isAnomaly);
anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
len_anomalyLength=length(anomalyLength(1,:));
%Ѱ����������ȡģ���źŵ���������
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