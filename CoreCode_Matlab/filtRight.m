function [normal_signal,filted_length]=filtRight(normal_signal,phase,tmp)
    len_anomaly=length(normal_signal);
    len_tmp=length(tmp);
    wwidth_half=floor(len_tmp/2);
    if phase < wwidth_half
        start_len=wwidth_half-phase;%后一个心跳信号需要往前补充的长度
        if len_anomaly > start_len  %异常区间长度大于需要补充的长度
            normal_signal(len_anomaly-start_len+1:len_anomaly)=tmp(1:start_len);
            filted_length=start_len;
        else %异常区间长度小于等于需要补充的长度
            temp_end=wwidth_half-phase;
            temp_start=temp_end-len_anomaly+1;
            normal_signal(1:len_anomaly)=tmp(temp_start:temp_end);
            filted_length=len_anomaly;
        end
    else
        if phase > wwidth_half
            start_len=len_tmp-(phase-wwidth_half);
            if len_anomaly > start_len
                normal_signal(len_anomaly-start_len+1:len_anomaly)=tmp(1:start_len);
                filted_length=start_len;
            else
                temp_end=start_len;
                temp_start=temp_end-len_anomaly+1;
                normal_signal(1:len_anomaly)=tmp(temp_start:temp_end);
                filted_length=len_anomaly;
            end
        else
            filted_length=0;
        end
    end
end