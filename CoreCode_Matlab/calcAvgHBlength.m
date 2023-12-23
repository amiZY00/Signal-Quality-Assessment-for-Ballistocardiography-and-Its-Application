function [avg_HB_length,filted]=calcAvgHBlength(S,bz,az)
    filted=filtHB(S,bz,az);
    top_points=findACFToppoints(filted);
    cycle_lengths=diff(top_points,1,2);
    temp_lengths=cycle_lengths(cycle_lengths(:)>=20);
    temp_lengths=temp_lengths(temp_lengths(:)<=75);
    avg_HB_length=sum(temp_lengths)/length(temp_lengths);
end