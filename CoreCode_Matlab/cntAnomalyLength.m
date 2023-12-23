function [AnomalyLength]=cntAnomalyLength(isAnomaly)
%���������쳣�ĳ���
%AnomalyLength����¼�쳣���ȵ����飬�±��ʾԭʼ�ź��д����ҵڼ������쳣��ֵΪ�����쳣��ĳ���
    n=length(isAnomaly);
    AnomalyLength=zeros(2,n);
    t=1;
    k=1;
    while k<=n
        cnt=0;
        while k<=n && isAnomaly(k)==0
            k=k+1;
        end
        temp_start=0;
        if k<=n && isAnomaly(k)==1
            temp_start=k;
        end
        while k<=n && isAnomaly(k)==1
            cnt=cnt+1;
            k=k+1;
        end
        AnomalyLength(1,t)=temp_start;
        AnomalyLength(2,t)=cnt;
        t=t+1;
    end
    AnomalyLength=AnomalyLength(:,AnomalyLength(1,:)~=0);
end
            