function [isAnomaly]=mergeAnomaly(isAnomaly,anomalyLength)
    len_S=length(isAnomaly);
    len_anomalyLength=length(anomalyLength(1,:));
    %�ϲ��쳣����
    threshold=200;%�ϲ����䳤����ֵ������С�������ֵ�����佫����Ϊ�쳣���䴦��
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