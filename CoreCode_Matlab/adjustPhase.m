function [phase]=adjustPhase(phase,len_tmp,temp_seg,jWaveLoc,type)
    assert(phase<=2*len_tmp);
    if phase<=len_tmp
        return;
    end
    len_jWaveLoc=length(jWaveLoc);
    half_wwidth=floor(len_tmp/2);
    len_seg=length(temp_seg);
    switch type
        case 'left'
            [MAX,loc]=max(temp_seg(jWaveLoc(len_jWaveLoc)+half_wwidth:len_seg));
            phase=(len_seg-jWaveLoc(len_jWaveLoc)-half_wwidth+1)-loc;
        case 'right'
            [MAX,loc]=max(temp_seg(1:jWaveLoc(1)-half_wwidth));
            phase=loc-1;
        otherwise
            fprintf('type should be in [left,right]');
    end
end