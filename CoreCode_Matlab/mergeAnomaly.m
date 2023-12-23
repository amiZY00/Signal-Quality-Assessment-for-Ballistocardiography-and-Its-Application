function [isAnomaly]=mergeAnomaly(isAnomaly,anomalyLength)
    len_S=length(isAnomaly);
    len_anomalyLength=length(anomalyLength(1,:));
    %合并异常区间
    threshold=200;%合并区间长度阈值，长度小于这个阈值的区间将被视为异常区间处理
    for k=1:len_anomalyLength
        if anomalyLength(1,k)<=threshold
            isAnomaly(1:anomalyLength(1,k))=1;
        end
        if len_S-anomalyLength(1,k)<threshold
            isAnomaly(anomalyLength(1,k):len_S)=1;
        end
        temp_end=anomalyLength(1,k)+anomalyLength(2,k)-1;
        if k<len_anomalyLength && anomalyLength(1,k+1)-temp_end-1<threshold
            isAnomaly(temp_end:anomalyLength(1,k+1))=1;
        end
    end
end