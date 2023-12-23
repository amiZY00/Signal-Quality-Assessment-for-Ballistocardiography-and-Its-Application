function [R]=cntVoteResults(frames,length,wwidth,lag)
%Param: frames: frames cutted from original series
%Param: length: length of the original series
    R=zeros(1,length);
    TF=isoutlier(frames,'gesd');
    n=size(frames,2);
    for k=1:n
        startLocation=lag*(k-1)+1;
        for t=1:wwidth
            if TF(t,k)
                R(startLocation+t-1)=R(startLocation+t-1)+1;
            end
        end
    end
end
