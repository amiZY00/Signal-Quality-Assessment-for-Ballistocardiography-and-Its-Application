function [normal_signal]=generateNormalSignal(phase,phase_extend,len_anomaly,tmp,type)
%根据相位，异常区间长度和信号模板来产生正常信号
%phase：异常区间旁边的正常区间中最近的J波到异常区间边界的距离
%len_anomaly：异常区间的长度
%tmp：信号模板
%type：填充类型left/right/bidirectional，表示计算出相位phase的是异常区间左边还是右边的J波
    len_tmp=length(tmp);
    %assert(phase>=0 && phase<=len_tmp,'phase:',num2str(phase),' must be less than length of tmp: ',num2str(len_tmp));%确保异常区间旁的一个心跳周期内有J波
    assert(phase>=0 && phase<=len_tmp,'phase must be less than length of tmp');%确保异常区间旁的一个心跳周期内有J波
    assert(phase_extend>=0 && phase_extend<=len_tmp,'phase must be less than length of tmp');%确保异常区间旁的一个心跳周期内有J波
    normal_signal=zeros(1,len_anomaly);
    switch type
        case 'left'
            [normal_signal,filted_length]=filtLeft(normal_signal,phase,tmp);
            if filted_length==len_anomaly
                return;
            end
            rest_len=len_anomaly-filted_length;
            n=floor(rest_len/len_tmp);
            rep_len=n*len_tmp;
            if n>0
                normal_signal(filted_length+1:filted_length+rep_len)=repmat(tmp,1,n);
            end
            temp_len=rest_len-rep_len;
            normal_signal(len_anomaly-temp_len+1:len_anomaly)=tmp(1:temp_len);
            %随机调整信号幅值大小
            s=randi([600,1100],1,n+2)/1000;
            weight=repelem(s,len_tmp);
            weight=weight(1:len_anomaly);
            normal_signal=normal_signal.*weight;
        case 'right'
            [normal_signal,filted_length]=filtRight(normal_signal,phase,tmp);
            if filted_length==len_anomaly
                return;
            end
            rest_len=len_anomaly-filted_length;
            n=floor(rest_len/len_tmp);
            rep_len=n*len_tmp;
            temp_len=rest_len-rep_len;
            if n>0
                normal_signal(temp_len+1:rest_len)=repmat(tmp,1,n);
            end
            normal_signal(1:temp_len)=tmp(len_tmp-temp_len+1:len_tmp);
            %随机调整信号幅值大小
            s=randi([600,1100],1,n+2)/1000;
            weight=repelem(s,len_tmp);
            weight=weight(1:len_anomaly);
            normal_signal=normal_signal.*weight;
        case 'bidirectional'
            [normal_signal,filted_length_left]=filtLeft(normal_signal,phase,tmp);
            if filted_length_left==len_anomaly
                return;
            end
            [normal_signal(filted_length_left+1:len_anomaly),filted_length_right]=filtRight(normal_signal(filted_length_left+1:len_anomaly),phase_extend,tmp);
            if filted_length_right==len_anomaly-filted_length_left
                return;
            end
            [normal_signal(1+filted_length_left:len_anomaly-filted_length_right),n_tmp]=adaptiveFill(len_anomaly-filted_length_left-filted_length_right,tmp,5);
            %随机调整信号幅值大小
            s=randi([600,1100],1,n_tmp+3)/1000;
            weight=repelem(s,len_tmp);
            weight=weight(1:len_anomaly);
            normal_signal=normal_signal.*weight;
        otherwise
            fprintf('type must be in [''right'',''left'',''Bidirectional'']');
    end
end
    