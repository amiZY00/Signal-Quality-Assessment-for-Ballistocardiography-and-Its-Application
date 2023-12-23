function [frames]=cut_into_frame(S,wwidth,lag)
%��ԭʼ�ź�S�г���wwidthΪ���ڿ�ȣ���lagΪ���ڼ����֡
    n=length(S);
    r=fix(n/lag-wwidth/lag+1);
    frames=zeros(r,wwidth);
    for k=1:r
        current_location=lag*(k-1)+1;
        frames(k,:)=S(current_location:current_location+wwidth-1);
    end
end
            
    
        