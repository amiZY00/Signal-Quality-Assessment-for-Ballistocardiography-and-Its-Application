function [jWaveLoc]=findJWaveLoc(filted,tmp,bz,az)
%�ҵ��ź�Ƭ��filted�е�j��λ��
%tmp��ģ���ź�
%bz,az����ͨ�˲�����
    % ��������غ���
    wwidth=length(tmp);
    half_width=floor(wwidth/2);
    len_signal=length(filted);
    result=zeros(1,len_signal);
    for k=1:len_signal
        if k <= half_width
            temp_start=half_width-(k-1)+1;
            temp_tmp=tmp(temp_start:end)';
            temp_signal=filted(1:k+half_width)';
            if filted(k)<mean(temp_signal)
                result(k)=0;
            else
                result(k)=corr(temp_tmp,temp_signal);
            end
            continue;
        end
        if len_signal-k < half_width
            temp_end=wwidth-(half_width-(len_signal-k));
            temp_tmp=tmp(1:temp_end)';
            temp_signal=filted(k-half_width:end)';
            if filted(k)<mean(temp_signal)
                result(k)=0;
            else
                result(k)=corr(temp_tmp,temp_signal);
            end
            continue;
        end
        temp_tmp=tmp(1:end)';
        temp_signal=filted(k-half_width:k+half_width)';
        if filted(k)<mean(temp_signal)
            result(k)=0;
        else
            result(k)=corr(temp_tmp,temp_signal);
        end
    end
    
    %��λJ��
    filted_result=filtHB(result,bz,az);
    len_filtedResult=length(filted_result);
    waveBottom=zeros(1,len_filtedResult);%filted_result�ź��еĲ��ȣ�����J������
    t=1;
    k=1;
    while k<len_filtedResult
        temp_start=k;
        while k<len_filtedResult && filted_result(k+1)<=filted_result(k)
            k=k+1;
        end
        while k<len_filtedResult && filted_result(k+1)>=filted_result(k)
            k=k+1;
        end
        temp_end=k;
        [MIN,loc]=min(filted_result(temp_start:temp_end));
        waveBottom(t)=temp_start+loc-1;
        t=t+1;
    end
    waveBottom=waveBottom(waveBottom(:)~=0);

    %�ڲ��ȱ�ǵ�����������J��
    len_waveBottom=length(waveBottom);
    jWaveLoc=zeros(1,len_waveBottom-1);
    t=1;
    k=1;
    while k<len_waveBottom
        [MAX,loc]=max(filted(waveBottom(k):waveBottom(k+1)));
        jWaveLoc(t)=waveBottom(k)+loc-1;
        t=t+1;
        k=k+1;
    end
end