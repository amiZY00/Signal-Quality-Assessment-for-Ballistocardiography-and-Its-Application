function [isAnomaly]=generateAnomaly(voteRatio)
%计算异常投票结果，1为异常，0为非异常
    n=length(voteRatio);
    isAnomaly=zeros(1,n);
    for k=1:n
        if voteRatio(k)>0.5
            isAnomaly(k)=1;
        end
    end
end