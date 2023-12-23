function [AR,ARN,AALN,AER]=assessQuality(isAnomaly,S)
len_S=length(S);
[anomalyLength]=cntAnomalyLength(isAnomaly);
anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
[isAnomaly]=mergeAnomaly(isAnomaly,anomalyLength);%合并异常区间
[anomalyLength]=cntAnomalyLength(isAnomaly);
anomalyLength=anomalyLength(:,anomalyLength(1,:)~=0);
AR=length(isAnomaly(isAnomaly(:)==1))/len_S;
ARN=length(anomalyLength(1,:));
if ARN<=1
    AALN=0;
else
    total=0;
    for t=1:ARN-1
        total=total+anomalyLength(1,t+1)-anomalyLength(1,t)-anomalyLength(2,t);
    end
    AALN=total/(ARN-1);
end
FFT=abs(fft(S));
x=(1:len_S)*50/len_S;
E_all=sum(FFT(1:round(16/x(1))));
E_local=sum(FFT((round(4/x(1)):round(8/x(1)))));
AER=E_local/E_all;


end