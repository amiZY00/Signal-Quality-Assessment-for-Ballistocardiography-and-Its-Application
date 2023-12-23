function [normal_signal]=generateNormalSignal(phase,phase_extend,len_anomaly,tmp,type)
%������λ���쳣���䳤�Ⱥ��ź�ģ�������������ź�
%phase���쳣�����Աߵ����������������J�����쳣����߽�ľ���
%len_anomaly���쳣����ĳ���
%tmp���ź�ģ��
%type���������left/right/bidirectional����ʾ�������λphase�����쳣������߻����ұߵ�J��
    len_tmp=length(tmp);
    %assert(phase>=0 && phase<=len_tmp,'phase:',num2str(phase),' must be less than length of tmp: ',num2str(len_tmp));%ȷ���쳣�����Ե�һ��������������J��
    assert(phase>=0 && phase<=len_tmp,'phase must be less than length of tmp');%ȷ���쳣�����Ե�һ��������������J��
    assert(phase_extend>=0 && phase_extend<=len_tmp,'phase must be less than length of tmp');%ȷ���쳣�����Ե�һ��������������J��
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
            %��������źŷ�ֵ��С
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
            %��������źŷ�ֵ��С
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
            %��������źŷ�ֵ��С
            s=randi([600,1100],1,n_tmp+3)/1000;
            weight=repelem(s,len_tmp);
            weight=weight(1:len_anomaly);
            normal_signal=normal_signal.*weight;
        otherwise
            fprintf('type must be in [''right'',''left'',''Bidirectional'']');
    end
end
    