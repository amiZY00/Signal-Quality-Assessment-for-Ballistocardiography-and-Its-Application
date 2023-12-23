function [isAnomaly]=calcSRAnomaly(S)
    [fshift,SRshift,Smap,Ashift]=calcSR(S);
    len=length(S);
    isAnomaly=zeros(1,len);
    
    avg=mean(Smap(50:len-50));
    dev=std(Smap(50:len-50));
    threshold=avg+4*dev;
    isAnomaly((Smap(:))>threshold)=1;
    isAnomaly(1:50)=0;
    isAnomaly(len-50:len)=0;
end