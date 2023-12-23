function [result]=addressAnomaly(filted,anomalyLength,tmp,bz_1,az_1,bz_2,az_2)
len_S=length(filted);
len_anomalyLength=length(anomalyLength(1,:));
for k=1:len_anomalyLength
    if k>1    
        temp_start=anomalyLength(1,k-1)+anomalyLength(2,k-1);%������������߽�
        temp_seg_left=filted(temp_start:anomalyLength(1,k)-1);%����������
        if k<len_anomalyLength %���˶���
            temp_seg_right=filted(anomalyLength(1,k)+anomalyLength(2,k):anomalyLength(1,k+1)-1);%����������
        else
            if anomalyLength(1,k)+anomalyLength(2,k)-1 < len_S %���˶���
                temp_seg_right=filted(anomalyLength(1,k)+anomalyLength(2,k):end);
            else %�����
                [jWaveLoc]=findJWaveLoc(temp_seg_left,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
                temp_jWave=temp_start+jWaveLoc(length(jWaveLoc))-1;%��Ҫ��J���������ź��е�λ���±�
                phase=anomalyLength(1,k)-temp_jWave-1;
                phase=adjustPhase(phase,length(tmp),temp_seg_left,jWaveLoc,'left');%ȷ��phaseС��ģ���źŵĳ���
                [normal_signal]=generateNormalSignal(phase,0,anomalyLength(2,k),tmp,'left');
                normal_signal=normal_signal*(mean(mas(abs(temp_seg_left)))/mean(max(abs(normal_signal))));%������ֵ
                filted_twice=filtHB(normal_signal,bz_1,az_1);
                filted(anomalyLength(1,k):anomalyLength(1,k)+anomalyLength(2,k)-1)=filted_twice;
                result=filtHB(filted,bz_1,az_1);
                return;
            end
        end
        [jWaveLoc]=findJWaveLoc(temp_seg_left,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
        temp_jWave=temp_start+jWaveLoc(length(jWaveLoc))-1;%��Ҫ��J���������ź��е�λ���±�
        phase=anomalyLength(1,k)-temp_jWave-1;
        phase=adjustPhase(phase,length(tmp),temp_seg_left,jWaveLoc,'left');%ȷ��phaseС��ģ���źŵĳ���
        [jWaveLoc]=findJWaveLoc(temp_seg_right,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
        phase_extend=jWaveLoc(1)-1;
        phase_extend=adjustPhase(phase_extend,length(tmp),temp_seg_right,jWaveLoc,'right');%ȷ��phaseС��ģ���źŵĳ���
        [normal_signal]=generateNormalSignal(phase,phase_extend,anomalyLength(2,k),tmp,'bidirectional');
        normal_signal=normal_signal*(mean([mean(max(abs(temp_seg_left))),mean(max(abs(temp_seg_right)))])/mean(max(abs(normal_signal))));%������ֵ
        filted_twice=filtHB(normal_signal,bz_1,az_1);
        filted(anomalyLength(1,k):anomalyLength(1,k)+anomalyLength(2,k)-1)=filted_twice;
%         result=filtHB(filted,bz_1,az_1);
    else
        normal_signal=0;
        flag=0;
        if anomalyLength(1,k)>1
            flag=flag+1;
        end
        if anomalyLength(1,k)+anomalyLength(2,k)-1<len_S
            flag=flag+2;
        end
        switch flag
            case 1%�����
                temp_seg_left=filted(1:anomalyLength(1,k)-1);
                [jWaveLoc]=findJWaveLoc(temp_seg_left,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
                phase=anomalyLength(1,k)-jWaveLoc(length(jWaveLoc))-1;
                phase=adjustPhase(phase,length(tmp),temp_seg_left,jWaveLoc,'left');%ȷ��phaseС��ģ���źŵĳ���
                [normal_signal]=generateNormalSignal(phase,0,anomalyLength(2,k),tmp,'left');
                normal_signal=normal_signal*(mean(max(abs(temp_seg_left)))/mean(max(abs(normal_signal))));%������ֵ
            case 2%�Ҷ���
                temp_start=anomalyLength(1,k)+anomalyLength(2,k);%������������߽�
                temp_seg_right=0;
                if len_anomalyLength>1
                    temp_seg_right=filted(temp_start:anomalyLength(1,k+1)-1);
                else
                    temp_seg_right=filted(temp_start:end);
                end
                [jWaveLoc]=findJWaveLoc(temp_seg_right,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
                phase=jWaveLoc(1)-1;
                phase=adjustPhase(phase,length(tmp),temp_seg_right,jWaveLoc,'right');%ȷ��phaseС��ģ���źŵĳ���
                [normal_signal]=generateNormalSignal(phase,0,anomalyLength(2,k),tmp,'right');
                normal_signal=normal_signal*(mean(max(abs(temp_seg_right)))/mean(max(abs(normal_signal))));%������ֵ
            case 3%���˶���
                temp_seg_left=filted(1:anomalyLength(1,k)-1);
                temp_start=anomalyLength(1,k)+anomalyLength(2,k);%������������߽�
                temp_seg_right=0;
                if len_anomalyLength>1
                    temp_seg_right=filted(temp_start:anomalyLength(1,k+1)-1);
                else
                    temp_seg_right=filted(temp_start:end);
                end
                [jWaveLoc]=findJWaveLoc(temp_seg_left,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
                phase=anomalyLength(1,k)-jWaveLoc(length(jWaveLoc))-1;
                phase=adjustPhase(phase,length(tmp),temp_seg_left,jWaveLoc,'left');%ȷ��phaseС��ģ���źŵĳ���
                [jWaveLoc]=findJWaveLoc(temp_seg_right,tmp,bz_2,az_2);%����������Ƭ���е�J��λ���±�
                phase_extend=jWaveLoc(1)-1;
                phase_extend=adjustPhase(phase_extend,length(tmp),temp_seg_right,jWaveLoc,'right');%ȷ��phaseС��ģ���źŵĳ���
                [normal_signal]=generateNormalSignal(phase,phase_extend,anomalyLength(2,k),tmp,'bidirectional');
                normal_signal=normal_signal*(mean([mean(max(abs(temp_seg_left))),mean(max(abs(temp_seg_right)))])/mean(max(abs(normal_signal))));%������ֵ
            otherwise
                fprintf('no normal signal!');
        end
        filted_twice=filtHB(normal_signal,bz_1,az_1);
        filted(anomalyLength(1,k):anomalyLength(1,k)+anomalyLength(2,k)-1)=filted_twice;
        %result=filtHB(filted,bz_1,az_1);
    end
    result=filtHB(filted,bz_1,az_1);
end