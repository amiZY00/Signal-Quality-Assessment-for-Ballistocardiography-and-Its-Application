function [isAnomaly]=generateAnomaly(voteRatio)
%�����쳣ͶƱ�����1Ϊ�쳣��0Ϊ���쳣
    n=length(voteRatio);
    isAnomaly=zeros(1,n);
    for k=1:n
        if voteRatio(k)>0.5
            isAnomaly(k)=1;
        end
    end
end