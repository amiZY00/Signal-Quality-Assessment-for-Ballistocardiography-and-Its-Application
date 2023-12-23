function [X]=filtHB(S,bz,az)
    %[B,A]=butter(10,[2/25 10/25]);
    X=filtfilt(bz,az,S);
end