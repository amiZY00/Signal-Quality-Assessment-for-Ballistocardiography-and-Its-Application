function [frames,voteResults,voteRatio,isAnomaly,anomalyLength]=calcMDESGAnomaly(S,wwidth,lag)
    n=length(S);
    frames=cut_into_frame(S,wwidth,lag);
    frames=frames';
    voteResults=cntVoteResults(frames,n,wwidth,lag);
    voteRatio=calcVoteRatio(voteResults,n,wwidth,lag);
    isAnomaly=generateAnomaly(voteRatio);
    anomalyLength=cntAnomalyLength(isAnomaly);
end