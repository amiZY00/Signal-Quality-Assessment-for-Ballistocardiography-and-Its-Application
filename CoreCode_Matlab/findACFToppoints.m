function [top_points]=findACFToppoints(filted)
%寻找经过滤波后的信号序列的自相关函数的极值点位置，这些极值点的定义如下：自相关函数中在显著为0区间外的长度超过4的连续点中的最大值
%filted：滤波后的信号序列
    [acf,lags,bounds] = autocorr(filted,length(filted)-1);
    len=length(acf);
    start=1;
    temp_max_points=zeros(2,50);
    r=1;
    t=1;
    k=1;
    while 1
        while k<=len && acf(k)>bounds(2) && acf(k)<bounds(1)  %跳过在置信区间内的点
            k=k+1;
        end
    
        if k>len
            break;
        end
    
        start=k;
        if acf(k)>=bounds(1)   
            while k<=len && acf(k)>=bounds(1)  %找到大于置信区间上界的连续区间
                k=k+1;
            end
            fin=k;
            if (fin-start)>=4
                [C,target_loc]=max(acf(start:fin));
                temp_max_points(1,r)=start+target_loc-1;
                r=r+1;
            end
        else
            while k<=len && acf(k)<=bounds(2)  %找到小于置信区间下界的连续区间
                k=k+1;
            end
            fin=k;
            if (fin-start)>=4
                [C,target_loc]=min(acf(start:fin));
                temp_max_points(2,t)=start+target_loc-1;
                t=t+1;
            end
        end
    end
    top_points=temp_max_points;
end