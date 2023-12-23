function [normal_signal,n_tmp]=adaptiveFill(len_anomaly,tmp,m)
    len_tmp=length(tmp);
    normal_signal=zeros(1,len_anomaly);
    n_tmp=floor(len_anomaly/len_tmp);
    rep_len=n_tmp*len_tmp;
    rest_len=len_anomaly-rep_len;
    if rest_len > 0.6*len_tmp
        start_len=floor((len_tmp-rest_len)/2);
        rest_item=tmp(start_len+1:start_len+rest_len);
        if n_tmp>0
            rest_item=[rest_item,repmat(tmp,1,n_tmp)];
        end
        normal_signal=rest_item;
    else
        if n_tmp>1
            len_interval=floor(rest_len/(n_tmp-1));
            rep_item=fillLog(tmp,len_interval,m);
            filt_length=0;
            if n_tmp>2
                filt_length=(len_tmp+len_interval)*(n_tmp-2);
                normal_signal(1:filt_length)=repmat(rep_item,1,n_tmp-2);
                rep_item=fillLog(tmp,rest_len-(n_tmp-2)*len_interval,m);
            end
            normal_signal(filt_length+1:len_anomaly)=[rep_item,tmp];
        else
            rest_item=fillLog(tmp,rest_len,m);
            if n_tmp>0
                normal_signal(1:len_anomaly)=rest_item;
            else
                normal_signal(1:len_anomaly)=rest_item(len_tmp+1:end);
            end
        end
    end
end