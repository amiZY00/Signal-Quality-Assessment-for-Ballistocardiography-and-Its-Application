function [voteRatio]=calcVoteRatio(R,length,wwidth,lag)
%Param: R: Anomaly Count Results calculated by cnyAnoamlyTimes.m
%Param: length: length of the original series
    voteNum=ones(1,length);
    n=fix(length/lag);
    threshold=floor(wwidth/lag);
    for k=1:n
        startLocation=lag*(k-1)+1;
        if k<threshold
            voteNum(startLocation:startLocation+lag-1)=k;
        else
            if k>n-threshold
                voteNum(startLocation:startLocation+lag-1)=n-k+1;
            else
                voteNum(startLocation:startLocation+lag-1)=threshold;
            end
        end
    end
    voteRatio=R./voteNum;
end
        