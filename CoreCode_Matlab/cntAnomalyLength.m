function [AnomalyLength]=cntAnomalyLength(isAnomaly)
%计算连续异常的长度
%AnomalyLength：记录异常长度的数组，下标表示原始信号中从左到右第几处的异常，值为连续异常点的长度
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
            